import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nexprime/models/chat_active_user_model.dart';
import 'package:nexprime/models/chat_history_model.dart';
import 'package:nexprime/models/chat_upload_model.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class ChatRepository {
  final ApiServices _apiServices = ApiServices.instance;

  Future<List<ChatActiveUserModel>> getActiveUsers() async {
    try {
      final response = await _apiServices.getServices('/chat/online-users');
      if (response != null && response is List) {
        return response.map((e) => ChatActiveUserModel.fromJson(e)).toList();
      }
    } catch (e) {
      errorLog('Error getting active users', e);
    }
    return [];
  }

  Future<List<ChatActiveUserModel>> getConversations() async {
    try {
      final response = await _apiServices.getServices('/chat/conversations');
      if (response != null && response is List) {
        return response.map((e) => ChatActiveUserModel.fromJson(e)).toList();
      }
    } catch (e) {
      errorLog('Error getting conversations', e);
    }
    return [];
  }

  Future<void> markChatAsRead(int userId) async {
    try {
      await _apiServices.postServices(url: '/chat/read/$userId');
    } catch (e) {
      errorLog('Error marking chat as read', e);
    }
  }

  Future<List<ChatHistoryModel>> getChatHistory(int userId) async {
    try {
      final response = await _apiServices.getServices('/chat/history/$userId');
      if (response != null && response is List) {
        return response.map((e) => ChatHistoryModel.fromJson(e)).toList();
      }
    } catch (e) {
      errorLog('Error getting chat history', e);
    }
    return [];
  }

  Future<ChatUploadModel?> uploadChatFile(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await _apiServices.postServices(
        url: '/chat/upload',
        body: formData,
      );

      if (response != null && response is Map<String, dynamic>) {
        return ChatUploadModel.fromJson(response);
      }
    } catch (e) {
      errorLog('Error uploading chat file', e);
    }
    return null;
  }
}
