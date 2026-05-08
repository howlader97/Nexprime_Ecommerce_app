import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/models/stream_notification_model.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/services/api/non_auth_api.dart';
import 'package:nexprime/services/storage/storage_services.dart';
import 'package:nexprime/utils/app_log.dart';

class StreamingRepository {
  ////////////// Contractures
  StreamingRepository._privetContractures();

  static final StreamingRepository _instance =
      StreamingRepository._privetContractures();

  static StreamingRepository get instance => _instance;

  /////////////// object
  ApiServices apiServices = ApiServices.instance;
  NonAuthApi nonAuthApi = NonAuthApi();
  AppApiUrl api = AppApiUrl.instance;
  StorageServices storageServices = StorageServices.instance;

  Future<List<StreamNotificationModel>> fetchNotification() async {
    List<StreamNotificationModel> streamNotificationModel = [];
    try {
      final response = await apiServices.getServices(api.streamNotification);

      if (response != null) {
        if (response['streams'] is List) {
          for (var item in response['streams']) {
            streamNotificationModel.add(StreamNotificationModel.fromJson(item));
          }
        }
      }
    } catch (e) {
      errorLog("Stream data", e);
    }
    return streamNotificationModel;
  }

  Future<bool> closeStream({required int streamId}) async {
    try {
      var response = await apiServices.patchServices(
        url: api.stopStream(streamId),
      );
      if (response is Map) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      errorLog("stream stop", e);
      return false;
    }
  }

  Future<String?> uploadImage({
    required File imageFile,
    String folder = "general",
  }) async {
    try {
      FormData body = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
        "folder": folder,
      });

      var response = await apiServices.postServices(
        url: api.uploadImage,
        body: body,
      );

      if (response != null && response['url'] != null) {
        return response['url'];
      }
    } catch (e) {
      errorLog("upload image repo error", e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> startStreaming({
    required String thumbnail,
    required String title,
    required String offer,
  }) async {
    try {
      Map<String, dynamic> body = {
        "thumbnail": thumbnail,
        "title": title,
        "offer": offer,
      };

      var response = await apiServices.postServices(
        url: api.liveStream,
        body: body,
      );

      if (response != null) {
        return response;
      }
    } catch (e) {
      errorLog("stream repo error", e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> joinStream({required int streamId}) async {
    try {
      var response = await apiServices.postServices(url: api.joinStream(streamId));

      if (response != null) {
        return response;
      }
    } catch (e) {
      errorLog("join stream repo error", e);
    }
    return null;
  }
}
