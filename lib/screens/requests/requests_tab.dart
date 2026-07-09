import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/models/food_request_model.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/food_request_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/widgets/common/empty_state.dart';
import 'package:resq_meal/navigation/feature_navigation.dart';
import 'package:resq_meal/widgets/common/loading_indicator.dart';
import 'package:resq_meal/widgets/feature/status_badge.dart';

class RequestsTab extends StatefulWidget {
  const RequestsTab({super.key});

  @override
  State<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _subscribe());
  }

  void _subscribe() {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    final provider = context.read<FoodRequestProvider>();
    final role = user.role;

    if (role == UserRole.ngo) {
      provider.watchNgoRequests(user.id);
    } else if (role == UserRole.donor) {
      provider.watchDonorRequests(user.id);
    } else {
      provider.watchNgoRequests(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FoodRequestProvider>();
    final role = context.watch<AuthProvider>().user?.role;

    if (provider.error != null && provider.requests.isEmpty) {
      return EmptyState(
        title: 'Could not load requests',
        subtitle: provider.error,
        icon: Icons.error_outline,
      );
    }

    if (provider.isLoading && provider.requests.isEmpty) {
      return const LoadingIndicator(message: 'Loading requests...');
    }

    return Stack(
      children: [
        RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => _subscribe(),
      child: ListView(
        padding: Responsive.pagePadding(context),
        children: [
          Text(
            role == UserRole.ngo ? 'Food requests' : 'Request history',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          if (provider.requests.isEmpty)
            const EmptyState(
              title: 'No requests',
              subtitle: 'Food requests will appear here in real time.',
              icon: Icons.inbox_outlined,
            )
          else
            ...provider.requests.map((r) => _RequestCard(request: r, role: role)),
        ],
      ),
    ),
        if (role == UserRole.ngo)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.extended(
              onPressed: () => FeatureNavigation.openCreateRequest(context),
              icon: const Icon(Icons.add),
              label: const Text('New request'),
            ),
          ),
      ],
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request, required this.role});

  final FoodRequestModel request;
  final UserRole? role;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => FeatureNavigation.openRequestDetail(context, request),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(request.title, style: Theme.of(context).textTheme.titleMedium),
                ),
                StatusBadge(label: request.status.name),
              ],
            ),
            const SizedBox(height: 6),
            Text(request.description, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text('Qty: ${request.quantityNeeded}', style: Theme.of(context).textTheme.bodySmall),
            if (role == UserRole.donor && request.status == FoodRequestStatus.pending) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      context.read<FoodRequestProvider>().approve(
                            request.id,
                            request.ngoId,
                          );
                    },
                    child: const Text('Accept'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<FoodRequestProvider>().reject(
                            request.id,
                            'Not available',
                            request.ngoId,
                          );
                    },
                    child: const Text('Reject'),
                  ),
                ],
              ),
            ],
            if (role == UserRole.ngo &&
                (request.status == FoodRequestStatus.approved ||
                    request.status == FoodRequestStatus.inProgress)) ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  if (request.donorId != null) {
                    context.read<FoodRequestProvider>().complete(
                          request.id,
                          request.donorId!,
                        );
                  }
                },
                child: const Text('Mark complete'),
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }
}
