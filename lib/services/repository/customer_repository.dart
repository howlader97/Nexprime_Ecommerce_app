import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class CustomerEditProfileRepository {
  CustomerEditProfileRepository._privateConstructor();
  static final CustomerEditProfileRepository _instance = CustomerEditProfileRepository._privateConstructor();
  static CustomerEditProfileRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<bool> updateProfile({
    required Map<String, dynamic> body,
    String? profileImagePath,
    String? coverImagePath,
  }) async {
    try {
      if (profileImagePath != null &&
          profileImagePath.isNotEmpty &&
          !profileImagePath.startsWith('http')) {
        final profileUrl = await _uploadImage(imageFile: File(profileImagePath));
        if (profileUrl != null) {
          body['profileImageUrl'] = profileUrl;
        }
      }
      if (coverImagePath != null &&
          coverImagePath.isNotEmpty &&
          !coverImagePath.startsWith('http')) {
        final coverUrl = await _uploadImage(imageFile: File(coverImagePath));
        if (coverUrl != null) {
          body['coverImageUrl'] = coverUrl;
        }
      }

      var response = await _apiServices.patchServices(
        url: _api.updateProfile,
        body: body,
      );

      return response != null;
    } catch (e) {
      errorLog("updateProfile CustomerRepository", e);
      return false;
    }
  }

  Future<String?> _uploadImage({
    required File imageFile,
    String folder = "general",
  }) async {
    try {
      String fileName = imageFile.path.split('/').last;
      var mimeType = lookupMimeType(imageFile.path);

      FormData body = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: MediaType.parse(
            mimeType ?? "application/octet-stream",
          ),
        ),
        "folder": folder,
      });

      var response = await _apiServices.postServices(
        url: _api.uploadImage,
        body: body,
      );

      if (response != null && response['url'] != null) {
        return response['url'];
      }
    } catch (e) {
      errorLog("_uploadImage CustomerRepository", e);
    }
    return null;
  }
}
