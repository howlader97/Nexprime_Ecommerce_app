import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/chat_active_user_model.dart';
import 'package:nexprime/services/repository/chat_repository.dart';

final chatActiveUsersProvider =
    StateNotifierProvider<
      ChatActiveUsersProvider,
      AsyncValue<List<ChatActiveUserModel>>
    >((ref) {
      return ChatActiveUsersProvider();
    });

class ChatActiveUsersProvider
    extends StateNotifier<AsyncValue<List<ChatActiveUserModel>>> {
  final ChatRepository _chatRepository = ChatRepository();

  ChatActiveUsersProvider() : super(const AsyncLoading()) {
    fetchActiveUsers();
  }

  Future<void> fetchActiveUsers() async {
    state = const AsyncLoading();
    try {
      final users = await _chatRepository.getActiveUsers();
      state = AsyncData(users);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
