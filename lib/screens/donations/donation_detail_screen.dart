import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/providers/chat_provider.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/navigation/feature_navigation.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/donation_provider.dart';
import 'package:resq_meal/providers/ngo_provider.dart';
import 'package:resq_meal/screens/donations/create_donation_screen.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/formatters.dart';
import 'package:resq_meal/utils/ui_helpers.dart';
import 'package:resq_meal/widgets/common/app_button.dart';
import 'package:resq_meal/widgets/common/loading_indicator.dart';
import 'package:resq_meal/widgets/feature/status_badge.dart';
import 'package:resq_meal/widgets/feature/status_timeline.dart';

class DonationDetailScreen extends StatefulWidget {
  const DonationDetailScreen({super.key, required this.donationId});

  final String donationId;

  @override
  State<DonationDetailScreen> createState() => _DonationDetailScreenState();
}

class _DonationDetailScreenState extends State<DonationDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DonationProvider>().watchSingleDonation(widget.donationId);
    });
  }

  List<StatusTimelineStep> _timeline(DonationStatus status) {
    const order = [
      DonationStatus.available,
      DonationStatus.reserved,
      DonationStatus.pickedUp,
      DonationStatus.delivered,
    ];
    final idx = order.indexOf(status);
    return order.map((s) {
      final i = order.indexOf(s);
      return StatusTimelineStep(
        label: s.name,
        isComplete: idx >= 0 && i < idx,
        isActive: s == status,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DonationProvider>();
    final user = context.watch<AuthProvider>().user;
    final donation = provider.selected;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation details'),
        actions: [
          if (donation != null && donation.donorId == user?.id)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                final ok = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => CreateDonationScreen(existing: donation),
                  ),
                );
                if (ok == true && mounted) {
                  provider.watchSingleDonation(widget.donationId);
                }
              },
            ),
        ],
      ),
      body: provider.isLoading && donation == null
          ? const LoadingIndicator(message: 'Loading donation...')
          : donation == null
              ? const Center(child: Text('Donation not found'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (donation.imageUrls.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          donation.imageUrls.first,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            donation.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        StatusBadge(label: donation.status.name),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(donation.description),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.category_outlined,
                      label: '${donation.category.label} · ${donation.quantity} ${donation.unit}',
                    ),
                    if (donation.expiryAt != null)
                      _InfoRow(
                        icon: Icons.schedule,
                        label: 'Expires ${Formatters.dateTime.format(donation.expiryAt!)}',
                      ),
                    if (donation.pickupLocation != null) ...[
                      _InfoRow(
                        icon: Icons.location_on_outlined,
                        label: donation.pickupLocation!.address,
                      ),
                      AppButton(
                        label: 'Track on map',
                        variant: AppButtonVariant.outlined,
                        onPressed: () =>
                            FeatureNavigation.openLocationTracking(context, donation: donation),
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (donation.ngoName != null)
                      _InfoRow(icon: Icons.groups_outlined, label: 'NGO: ${donation.ngoName}'),
                    const SizedBox(height: 24),
                    Text('Status tracking', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    StatusTimeline(steps: _timeline(donation.status)),
                    const SizedBox(height: 24),
                    if (user?.role == UserRole.ngo) ...[
                      AppButton(
                        label: 'Create food request',
                        variant: AppButtonVariant.outlined,
                        onPressed: () => FeatureNavigation.openCreateRequest(context, donation: donation),
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (user?.role == UserRole.ngo &&
                        donation.status == DonationStatus.available) ...[
                      AppButton(
                        label: 'Accept donation',
                        isLoading: provider.isSaving,
                        onPressed: provider.isSaving
                            ? null
                            : () async {
                                final ngo = context.read<NgoProvider>().current;
                                final orgName = ngo?.organizationName ?? user!.displayName ?? 'NGO';
                                final ngoId = ngo?.id;
                                if (ngoId == null) {
                                  UiHelpers.showError(context, 'Complete NGO registration first');
                                  return;
                                }
                                final ok = await provider.acceptDonation(
                                  donationId: donation.id,
                                  ngoId: ngoId,
                                  ngoName: orgName,
                                  donorId: donation.donorId,
                                );
                                if (!context.mounted) return;
                                if (ok) {
                                  UiHelpers.showSuccess(context, 'Donation accepted');
                                } else {
                                  UiHelpers.showError(context, provider.error);
                                }
                              },
                      ),
                      const SizedBox(height: 8),
                      AppButton(
                        label: 'Schedule pickup',
                        variant: AppButtonVariant.outlined,
                        onPressed: () => FeatureNavigation.openSchedulePickup(context, donation),
                      ),
                    ],
                    if (user != null &&
                        (user.role == UserRole.donor || user.role == UserRole.ngo)) ...[
                      const SizedBox(height: 8),
                      AppButton(
                        label: 'Message',
                        variant: AppButtonVariant.outlined,
                        onPressed: () async {
                          final otherId = user.role == UserRole.donor
                              ? donation.ngoId
                              : donation.donorId;
                          final otherName = user.role == UserRole.donor
                              ? donation.ngoName
                              : donation.donorName;
                          if (otherId == null || otherName == null) {
                            UiHelpers.showError(context, 'No partner to message yet');
                            return;
                          }
                          final chatId = await context.read<ChatProvider>().createChat(
                                participantIds: [user.id, otherId],
                                participantNames: {
                                  user.id: user.displayName ?? user.email,
                                  otherId: otherName,
                                },
                                type: ChatType.donorNgo,
                                relatedDonationId: donation.id,
                              );
                          if (!context.mounted || chatId == null) return;
                          FeatureNavigation.openChatDetail(
                            context,
                            chatId: chatId,
                            title: otherName,
                            participantIds: [user.id, otherId],
                          );
                        },
                      ),
                      AppButton(
                        label: 'QR verification',
                        variant: AppButtonVariant.outlined,
                        onPressed: () => FeatureNavigation.openQrVerify(context, donation.id),
                      ),
                      const SizedBox(height: 8),
                      AppButton(
                        label: 'Pickup QR',
                        variant: AppButtonVariant.outlined,
                        onPressed: () => FeatureNavigation.openQrDisplay(
                          context,
                          donation.id,
                          type: QrVerificationType.pickup,
                        ),
                      ),
                      AppButton(
                        label: 'Delivery QR',
                        variant: AppButtonVariant.outlined,
                        onPressed: () => FeatureNavigation.openQrDisplay(
                          context,
                          donation.id,
                          type: QrVerificationType.delivery,
                        ),
                      ),
                    ],
                  ],
                ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
