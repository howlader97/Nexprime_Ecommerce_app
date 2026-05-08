import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/chat_history_model.dart';
import 'package:nexprime/models/chat_message_payload.dart';
import 'package:nexprime/services/sockets/chat_websocket_service.dart';
import 'package:nexprime/services/repository/chat_repository.dart';
import 'package:nexprime/utils/app_log.dart';

class ChatMessagesState {
  final AsyncValue<List<ChatHistoryModel>> messages;
  final ChatHistoryModel? replyingToMessage;

  ChatMessagesState({
    required this.messages,
    this.replyingToMessage,
  });

  ChatMessagesState copyWith({
    AsyncValue<List<ChatHistoryModel>>? messages,
    ChatHistoryModel? replyingToMessage,
    bool clearReply = false,
  }) {
    return ChatMessagesState(
      messages: messages ?? this.messages,
      replyingToMessage: clearReply ? null : (replyingToMessage ?? this.replyingToMessage),
    );
  }
}

final chatMessagesProvider =
    StateNotifierProvider.family<
      ChatMessagesProvider,
      ChatMessagesState,
      int
    >((ref, userId) {
      return ChatMessagesProvider(userId, ref);
    });

class ChatMessagesProvider
    extends StateNotifier<ChatMessagesState> {
  final int userId;
  final Ref ref;
  final ChatRepository _chatRepository = ChatRepository();

  ChatWebsocketService get _websocketService => ref.read(chatWebsocketProvider);

  ChatMessagesProvider(this.userId, this.ref) : super(ChatMessagesState(messages: const AsyncLoading())) {
    _initialize();
  }

  Future<void> _initialize() async {
    await fetchChatHistory();
    await _connectWebSocket();
  }

  void setReplyingTo(ChatHistoryModel? message) {
    state = state.copyWith(replyingToMessage: message, clearReply: message == null);
  }

  Future<void> fetchChatHistory() async {
    state = state.copyWith(messages: const AsyncLoading());
    try {
      final messages = await _chatRepository.getChatHistory(userId);
      // Reverse messages because backend returns oldest first, and our ListView is reversed.
      state = state.copyWith(messages: AsyncData(messages.reversed.toList()));
    } catch (e, stackTrace) {
      state = state.copyWith(messages: AsyncError(e, stackTrace));
    }
  }

  Future<void> _connectWebSocket() async {
    await _websocketService.connect();
    _websocketService.stream?.listen(
      (event) {
        try {
          final decoded = json.decode(event);
          final newMessage = ChatHistoryModel.fromJson(decoded);

          // Only add if relevant to this conversation
          if (newMessage.senderId == userId || newMessage.receiverId == userId) {
            state.messages.whenData((messages) {
              final updatedList = List<ChatHistoryModel>.from(messages)
                ..insert(0, newMessage);
              state = state.copyWith(messages: AsyncData(updatedList));
            });
          }
        } catch (e) {
          errorLog("WebSocket Listen Parsing Error", e);
        }
      },
      onError: (error) {
        errorLog("WebSocket Error", error);
      },
    );
  }

  void sendTextMessage(String text) {
    if (text.trim().isEmpty) return;

    final payload = ChatMessagePayload(
      content: text.trim(),
      type: "TEXT",
      receiverId: userId,
      replyToId: state.replyingToMessage?.id,
    );

    _websocketService.sendMessage(payload.toJson());
    setReplyingTo(null); // Clear reply after sending
  }

  Future<void> sendImageMessage(File imageFile) async {
    try {
      final uploadResponse = await _chatRepository.uploadChatFile(imageFile);
      if (uploadResponse != null && uploadResponse.url != null) {
        final payload = ChatMessagePayload(
          content: uploadResponse.url!,
          type: "IMAGE",
          receiverId: userId,
          replyToId: state.replyingToMessage?.id,
        );
        _websocketService.sendMessage(payload.toJson());
        setReplyingTo(null); // Clear reply after sending
      }
    } catch (e) {
      errorLog("Pusher Image Send Error", e);
    }
  }

}
