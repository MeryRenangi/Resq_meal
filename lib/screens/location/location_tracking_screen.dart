import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resq_meal/models/donation_model.dart';
import 'package:resq_meal/models/location_model.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/widgets/layout/responsive_content.dart';

class LocationTrackingScreen extends StatefulWidget {
  const LocationTrackingScreen({super.key, this.donation});

  final DonationModel? donation;

  @override
  State<LocationTrackingScreen> createState() => _LocationTrackingScreenState();
}

class _LocationTrackingScreenState extends State<LocationTrackingScreen> {
  GoogleMapController? _mapController;
  LatLng? _target;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final pickup = widget.donation?.pickupLocation;
    if (pickup?.latitude != null && pickup?.longitude != null) {
      setState(() {
        _target = LatLng(pickup!.latitude!, pickup.longitude!);
        _loading = false;
      });
      return;
    }

    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _error = 'Location permission denied';
          _target = const LatLng(37.7749, -122.4194);
          _loading = false;
        });
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      setState(() {
        _target = LatLng(pos.latitude, pos.longitude);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _target = const LatLng(37.7749, -122.4194);
        _loading = false;
      });
    }
  }

  Set<Marker> _markers() {
    final t = _target;
    if (t == null) return {};
    final loc = widget.donation?.pickupLocation;
    return {
      Marker(
        markerId: const MarkerId('pickup'),
        position: t,
        infoWindow: InfoWindow(
          title: widget.donation?.title ?? 'Pickup location',
          snippet: loc?.address ?? 'ResQ Meal pickup point',
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final mapHeight = Responsive.of(context) == ScreenSize.mobile ? 320.0 : 480.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Location tracking')),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : ResponsiveContent(
              child: ListView(
                children: [
                  if (widget.donation != null) ...[
                    Text(widget.donation!.title,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      widget.donation!.pickupLocation?.address ?? 'Address not set',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(_error!, style: const TextStyle(color: AppColors.warning)),
                    ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: mapHeight,
                      child: _target == null
                          ? const Center(child: Text('Map unavailable'))
                          : GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: _target!,
                                zoom: 14,
                              ),
                              markers: _markers(),
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              onMapCreated: (c) => _mapController = c,
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.donation?.pickupLocation != null)
                    _LocationDetailsCard(location: widget.donation!.pickupLocation!),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

class _LocationDetailsCard extends StatelessWidget {
  const _LocationDetailsCard({required this.location});

  final LocationModel location;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.location_on, color: AppColors.primary),
        title: Text(location.address),
        subtitle: Text(
          [
            if (location.city != null) location.city,
            if (location.label != null) location.label,
          ].whereType<String>().join(' · '),
        ),
      ),
    );
  }
}
