import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/notification_model.dart';
import 'package:resq_meal/navigation/feature_navigation.dart';
import 'package:resq_meal/providers/notification_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/formatters.dart';
import 'package:resq_meal/widgets/common/app_button.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key, required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: Icon(_iconForType(notification.type), color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(notification.title, style: Theme.of(context).textTheme.headlineSmall),
          if (notification.createdAt != null) ...[
            const SizedBox(height: 4),
            Text(
              Formatters.dateTime.format(notification.createdAt!),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 16),
          Text(notification.body, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Chip(
            label: Text(notification.type.name),
            backgroundColor: AppColors.surfaceVariant,
            side: BorderSide.none,
          ),
          const SizedBox(height: 32),
          if (notification.referenceId != null)
            AppButton(
              label: 'Open related item',
              onPressed: () {
                context.read<NotificationProvider>().markRead(notification.id);
                FeatureNavigation.openFromNotification(context, notification);
              },
            ),
        ],
      ),
    );
  }

  IconData _iconForType(dynamic type) {
    final name = type.toString();
    if (name.contains('donation')) return Icons.volunteer_activism_outlined;
    if (name.contains('request')) return Icons.inbox_outlined;
    if (name.contains('chat')) return Icons.chat_bubble_outline;
    if (name.contains('delivery')) return Icons.local_shipping_outlined;
    return Icons.notifications_outlined;
  }
}
