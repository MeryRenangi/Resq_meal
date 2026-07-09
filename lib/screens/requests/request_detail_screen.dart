import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/models/food_request_model.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/navigation/feature_navigation.dart';
import 'package:resq_meal/screens/donations/donation_detail_screen.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/food_request_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/formatters.dart';
import 'package:resq_meal/utils/ui_helpers.dart';
import 'package:resq_meal/widgets/common/app_button.dart';
import 'package:resq_meal/widgets/feature/status_badge.dart';
import 'package:resq_meal/widgets/feature/status_timeline.dart';

class RequestDetailScreen extends StatelessWidget {
  const RequestDetailScreen({super.key, required this.request});

  final FoodRequestModel request;

  List<StatusTimelineStep> _timeline(FoodRequestStatus status) {
    const order = [
      FoodRequestStatus.pending,
      FoodRequestStatus.approved,
      FoodRequestStatus.inProgress,
      FoodRequestStatus.completed,
    ];
    final idx = order.indexOf(status);
    if (status == FoodRequestStatus.rejected) {
      return [StatusTimelineStep(label: 'Rejected', isComplete: true, isActive: true)];
    }
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
    final provider = context.watch<FoodRequestProvider>();
    final user = context.watch<AuthProvider>().user;
    final role = user?.role;

    return Scaffold(
      appBar: AppBar(title: const Text('Request details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(request.title, style: Theme.of(context).textTheme.headlineSmall),
              ),
              StatusBadge(label: request.status.name),
            ],
          ),
          const SizedBox(height: 8),
          Text(request.description),
          const SizedBox(height: 12),
          Text('NGO: ${request.ngoName}', style: Theme.of(context).textTheme.bodyMedium),
          Text('Quantity: ${request.quantityNeeded}'),
          if (request.rejectionReason != null)
            Text(
              'Reason: ${request.rejectionReason}',
              style: const TextStyle(color: AppColors.error),
            ),
          if (request.completedAt != null)
            Text('Completed ${Formatters.dateTime.format(request.completedAt!)}'),
          const SizedBox(height: 24),
          Text('Status tracking', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          StatusTimeline(steps: _timeline(request.status)),
          const SizedBox(height: 24),
          if (role == UserRole.donor && request.status == FoodRequestStatus.pending) ...[
            AppButton(
              label: 'Accept request',
              isLoading: provider.isSaving,
              onPressed: provider.isSaving
                  ? null
                  : () async {
                      final ok = await provider.approve(request.id, request.ngoId);
                      if (!context.mounted) return;
                      if (ok) {
                        UiHelpers.showSuccess(context, 'Request approved');
                        Navigator.pop(context);
                      } else {
                        UiHelpers.showError(context, provider.error);
                      }
                    },
            ),
            const SizedBox(height: 8),
            AppButton(
              label: 'Reject request',
              variant: AppButtonVariant.outlined,
              isLoading: provider.isSaving,
              onPressed: provider.isSaving
                  ? null
                  : () async {
                      final ok = await provider.reject(
                        request.id,
                        'Not available at this time',
                        request.ngoId,
                      );
                      if (!context.mounted) return;
                      if (ok) {
                        UiHelpers.showSuccess(context, 'Request rejected');
                        Navigator.pop(context);
                      } else {
                        UiHelpers.showError(context, provider.error);
                      }
                    },
            ),
          ],
          if (role == UserRole.ngo &&
              (request.status == FoodRequestStatus.approved ||
                  request.status == FoodRequestStatus.inProgress)) ...[
            const SizedBox(height: 8),
            AppButton(
              label: 'Complete request',
              isLoading: provider.isSaving,
              onPressed: provider.isSaving || request.donorId == null
                  ? null
                  : () async {
                      final ok = await provider.complete(request.id, request.donorId!);
                      if (!context.mounted) return;
                      if (ok) {
                        UiHelpers.showSuccess(context, 'Request completed');
                        Navigator.pop(context);
                      } else {
                        UiHelpers.showError(context, provider.error);
                      }
                    },
            ),
          ],
          if (request.donationId != null) ...[
            const SizedBox(height: 8),
            AppButton(
              label: 'View linked donation',
              variant: AppButtonVariant.outlined,
              onPressed: () => FeatureNavigation.push(
                context,
                DonationDetailScreen(donationId: request.donationId!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
