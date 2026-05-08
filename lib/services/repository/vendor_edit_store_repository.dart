import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class VendorEditStoreRepository {
  VendorEditStoreRepository._privateConstructor();
  static final VendorEditStoreRepository _instance = VendorEditStoreRepository._privateConstructor();
  static VendorEditStoreRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<bool> updateStoreProfile({
    required String name,
    required String bio,
    required String address,
    File? photo,
    File? coverPhoto,
  }) async {
    try {
      Map<String, dynamic> data = {
        'name': name,
        'bio': bio,
        'address': address,
      };

      if (photo != null) {
        data['photo'] = await MultipartFile.fromFile(
          photo.path,
          filename: photo.path.split('/').last,
        );
      }

      if (coverPhoto != null) {
        data['cover_photo'] = await MultipartFile.fromFile(
          coverPhoto.path,
          filename: coverPhoto.path.split('/').last,
        );
      }

      FormData formData = FormData.fromMap(data);

      var response = await _apiServices.patchServices(
        url: _api.vendorStoreMe,
        body: formData,
      );

      return response != null;
    } catch (e) {
      errorLog("VendorEditStoreRepository updateStoreProfile", e);
      return false;
    }
  }
}
