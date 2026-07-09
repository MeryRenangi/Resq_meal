import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/navigation/feature_navigation.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/notification_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/widgets/common/empty_state.dart';
import 'package:resq_meal/widgets/common/loading_indicator.dart';
import 'package:resq_meal/widgets/layout/responsive_content.dart';
import 'package:resq_meal/widgets/notifications/realtime_notification_strip.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.id;
      if (userId != null) context.read<NotificationProvider>().watch(userId);
    });
  }

  IconData _icon(NotificationType type) => switch (type) {
        NotificationType.donation => Icons.volunteer_activism_outlined,
        NotificationType.request => Icons.inbox_outlined,
        NotificationType.chat => Icons.chat_bubble_outline,
        NotificationType.delivery => Icons.local_shipping_outlined,
        NotificationType.system => Icons.info_outline,
      };

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              final userId = context.read<AuthProvider>().user?.id;
              if (userId != null) provider.markAllRead(userId);
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: provider.isLoading && provider.notifications.isEmpty
          ? const LoadingIndicator(message: 'Loading notifications...')
          : provider.notifications.isEmpty
              ? ResponsiveContent(
                  child: const EmptyState(
                    title: 'No notifications',
                    subtitle: 'Alerts for donations, requests, chat, and delivery appear here.',
                    icon: Icons.notifications_none_outlined,
                  ),
                )
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    final userId = context.read<AuthProvider>().user?.id;
                    if (userId != null) provider.watch(userId);
                  },
                  child: ResponsiveContent(
                    padding: EdgeInsets.zero,
                    child: ListView.builder(
                  itemCount: provider.notifications.length + 1,
                  itemBuilder: (_, i) {
                    if (i == 0) return const RealtimeNotificationStrip();
                    final n = provider.notifications[i - 1];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: n.isRead
                            ? AppColors.surfaceVariant
                            : AppColors.primary.withValues(alpha: 0.15),
                        child: Icon(
                          _icon(n.type),
                          color: n.isRead ? AppColors.textSecondary : AppColors.primary,
                        ),
                      ),
                      title: Text(n.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(n.body),
                      onTap: () {
                        provider.markRead(n.id);
                        FeatureNavigation.openNotificationDetail(context, n);
                      },
                    );
                  },
                ),
                  ),
                ),
    );
  }
}
