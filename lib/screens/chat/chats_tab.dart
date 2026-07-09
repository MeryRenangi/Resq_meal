import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/navigation/feature_navigation.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/chat_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/formatters.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/widgets/common/empty_state.dart';
import 'package:resq_meal/widgets/common/loading_indicator.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({super.key});

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.id;
      if (userId != null) context.read<ChatProvider>().watchChats(userId);
    });
  }

  String _titleForChat(String userId, Map<String, String> names) {
    final others = names.entries.where((e) => e.key != userId).map((e) => e.value);
    if (others.isNotEmpty) return others.join(', ');
    return names.values.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final userId = context.watch<AuthProvider>().user?.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: chat.isLoading && chat.chats.isEmpty
          ? const LoadingIndicator(message: 'Loading chats...')
          : chat.chats.isEmpty
              ? const EmptyState(
                  title: 'No conversations',
                  subtitle: 'Start chatting from a donation or request.',
                  icon: Icons.chat_bubble_outline,
                )
              : ListView(
                  padding: Responsive.pagePadding(context),
                  children: [
                    ...chat.chats.map((c) {
                      final unread = userId != null ? (c.unreadCounts[userId] ?? 0) : 0;
                      final title = userId != null
                          ? _titleForChat(userId, c.participantNames)
                          : c.participantNames.values.join(', ');
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.surfaceVariant,
                            child: Text(
                              title.isNotEmpty ? title[0].toUpperCase() : '?',
                              style: const TextStyle(color: AppColors.primaryDark),
                            ),
                          ),
                          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(
                            c.lastMessage ?? 'No messages yet',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (c.lastMessageAt != null)
                                Text(
                                  Formatters.shortDate.format(c.lastMessageAt!),
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              if (unread > 0) ...[
                                const SizedBox(height: 4),
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: AppColors.primary,
                                  child: Text(
                                    '$unread',
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          onTap: () => FeatureNavigation.openChatDetail(
                            context,
                            chatId: c.id,
                            title: title,
                            participantIds: c.participantIds,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
    );
  }
}
