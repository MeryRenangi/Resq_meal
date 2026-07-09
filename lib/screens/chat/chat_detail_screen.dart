import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/chat_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.title,
    required this.participantIds,
  });

  final String chatId;
  final String title;
  final List<String> participantIds;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().watchMessages(widget.chatId);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    final others = widget.participantIds.where((id) => id != user.id).toList();
    final success = await context.read<ChatProvider>().sendMessage(
          chatId: widget.chatId,
          senderId: user.id,
          senderName: user.displayName ?? user.email,
          text: text,
          otherParticipantIds: others,
        );
    if (success) _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final userId = context.watch<AuthProvider>().user?.id;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: chat.messages.length,
              itemBuilder: (_, i) {
                final msg = chat.messages[i];
                final isMe = msg.senderId == userId;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment:
                        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isMe ? AppColors.primary : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          msg.text,
                          style: TextStyle(
                            color: isMe ? AppColors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isMe)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              msg.isRead ? Icons.done_all : Icons.done,
                              size: 14,
                              color: msg.isRead ? AppColors.primary : AppColors.textHint,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              msg.isRead ? 'Read' : 'Sent',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.textHint,
                                  ),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: chat.isSending ? null : _send,
                    icon: chat.isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
