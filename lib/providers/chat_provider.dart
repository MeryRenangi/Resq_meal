import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:resq_meal/core/repository_exception.dart';
import 'package:resq_meal/models/chat_model.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/models/message_model.dart';
import 'package:resq_meal/services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider(this._service);

  final ChatService? _service;

  List<ChatModel> _chats = [];
  List<MessageModel> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;
  String? _error;
  StreamSubscription<List<ChatModel>>? _chatsSub;
  StreamSubscription<List<MessageModel>>? _messagesSub;

  List<ChatModel> get chats => _chats;
  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get error => _error;

  void watchChats(String userId) {
    final service = _service;
    if (service == null) return;
    _chatsSub?.cancel();
    _isLoading = true;
    notifyListeners();
    _chatsSub = service.watchUserChats(userId).listen(
      (list) {
        _chats = list;
        _isLoading = false;
        notifyListeners();
      },
      onError: _handleError,
    );
  }

  void watchMessages(String chatId) {
    final service = _service;
    if (service == null) return;
    _messagesSub?.cancel();
    _messagesSub = service.watchMessages(chatId).listen(
      (list) {
        _messages = list.reversed.toList();
        notifyListeners();
      },
      onError: _handleError,
    );
  }

  Future<String?> createChat({
    required List<String> participantIds,
    required Map<String, String> participantNames,
    required ChatType type,
    String? relatedDonationId,
  }) async {
    final service = _service;
    if (service == null) return null;
    try {
      return await service.createChat(
        participantIds: participantIds,
        participantNames: participantNames,
        type: type,
        relatedDonationId: relatedDonationId,
      );
    } catch (e) {
      _error = e is RepositoryException ? e.message : e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String text,
    required List<String> otherParticipantIds,
  }) async {
    final service = _service;
    if (service == null) return false;
    _isSending = true;
    notifyListeners();
    try {
      await service.sendMessage(
        chatId: chatId,
        senderId: senderId,
        senderName: senderName,
        text: text,
        otherParticipantIds: otherParticipantIds,
      );
      return true;
    } catch (e) {
      _error = e is RepositoryException ? e.message : e.toString();
      return false;
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  void _handleError(Object e) {
    _error = e is RepositoryException ? e.message : e.toString();
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _chatsSub?.cancel();
    _messagesSub?.cancel();
    super.dispose();
  }
}
