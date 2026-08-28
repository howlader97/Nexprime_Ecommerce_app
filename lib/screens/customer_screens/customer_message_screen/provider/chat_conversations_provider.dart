import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/chat_active_user_model.dart';
import 'package:nexprime/models/chat_history_model.dart';
import 'package:nexprime/services/repository/chat_repository.dart';
import 'package:nexprime/services/sockets/chat_websocket_service.dart';
import 'package:nexprime/services/storage/storage_services.dart';
import 'package:nexprime/utils/app_log.dart';

final chatConversationsProvider =
    StateNotifierProvider<
      ChatConversationsProvider,
      AsyncValue<List<ChatActiveUserModel>>
    >((ref) {
      return ChatConversationsProvider(ref);
    });

class ChatConversationsProvider
    extends StateNotifier<AsyncValue<List<ChatActiveUserModel>>> {
  final Ref ref;
  final ChatRepository _chatRepository = ChatRepository();
  bool _isListening = false;
  int?
  _activeChatUserId; // Track who we are currently chatting with to prevent phantom unreads!
  StreamSubscription? _subscription;

  ChatConversationsProvider(this.ref) : super(const AsyncLoading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await fetchConversations();
    _listenToWebsocket();
  }

  void setActiveChatUser(int? userId) {
    _activeChatUserId = userId;
    if (userId != null) {
      markAsRead(userId);
    }
  }

  Future<void> fetchConversations() async {
    state = const AsyncLoading();
    try {
      final conversations = await _chatRepository.getConversations();
      state = AsyncData(conversations);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  void _listenToWebsocket() {
    if (_isListening) return;
    _isListening = true;

    final websocketService = ref.read(chatWebsocketProvider);
    websocketService.connect().then((_) {
      _subscription = websocketService.stream?.listen((event) async {
        try {
          final decoded = json.decode(event);
          final newMessage = ChatHistoryModel.fromJson(decoded);
          await _handleNewMessage(newMessage);
        } catch (e) {
          errorLog("ChatConversationsProvider WebSocket Parse Error", e);
        }
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _handleNewMessage(ChatHistoryModel message) async {
    final myId = await StorageServices.instance.getUserId();
    state.whenData((currentList) {
      final otherUserId = message.senderId == myId
          ? message.receiverId
          : message.senderId;

      final index = currentList.indexWhere((u) => u.userId == otherUserId);

      if (index != -1) {
        final existingUser = currentList[index];
        bool isFromMe = message.senderId == myId;

        // Don't mark unread if the message is from me OR if I am currently staring at this active chat
        bool isActivelyReading = (_activeChatUserId == otherUserId);

        int newUnreadCount = existingUser.unreadCount;
        if (!isFromMe && !isActivelyReading) {
          newUnreadCount += 1;
        } else if (!isFromMe && isActivelyReading) {
          newUnreadCount = 0; // Instantly read since we are on the screen
          _chatRepository.markChatAsRead(otherUserId); // Tell backend!
        }

        final updatedUser = ChatActiveUserModel(
          id: existingUser.id,
          userId: existingUser.userId,
          fullname: existingUser.fullname,
          email: existingUser.email,
          isOnline: existingUser.isOnline,
          lastActiveAt: existingUser.lastActiveAt,
          lastMessage: message.type == "IMAGE" ? "Photo" : message.content,
          lastMessageTime: message.createdAt ?? existingUser.lastMessageTime,
          unreadCount: newUnreadCount,
          profileImageUrl: existingUser.profileImageUrl,
        );

        final newList = List<ChatActiveUserModel>.from(currentList);
        newList.removeAt(index);
        newList.insert(0, updatedUser);

        state = AsyncData(newList);
      } else {
        fetchConversations();
      }
    });
  }

  void markAsRead(int userId) {
    state.whenData((currentList) {
      final index = currentList.indexWhere((u) => u.userId == userId);
      if (index != -1) {
        final existingUser = currentList[index];
        if (existingUser.unreadCount > 0) {
          _chatRepository.markChatAsRead(userId); // Tell backend we read it

          final updatedUser = ChatActiveUserModel(
            id: existingUser.id,
            userId: existingUser.userId,
            fullname: existingUser.fullname,
            email: existingUser.email,
            isOnline: existingUser.isOnline,
            lastActiveAt: existingUser.lastActiveAt,
            lastMessage: existingUser.lastMessage,
            lastMessageTime: existingUser.lastMessageTime,
            unreadCount: 0,
            profileImageUrl: existingUser.profileImageUrl,
          );

          final newList = List<ChatActiveUserModel>.from(currentList);
          newList[index] = updatedUser;
          state = AsyncData(newList);
        }
      }
    });
  }
}
