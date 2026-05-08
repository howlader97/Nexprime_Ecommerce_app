import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class VendorProductRepository {
  /////////////// constructor
  VendorProductRepository._privateConstructor();

  static final VendorProductRepository _instance =
      VendorProductRepository._privateConstructor();

  static VendorProductRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<bool> addProduct(Map<String, dynamic> data, List<File> images) async {
    try {
      FormData formData = FormData.fromMap(data);
      for (var file in images) {
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }

      var response = await _apiServices.postServices(
        url: _api.vendorProducts,
        body: formData,
      );

      return response != null;
    } catch (e) {
      errorLog("VendorProductRepository addProduct", e);
      return false;
    }
  }

  Future<bool> deleteProduct(int productId) async {
    try {
      var response = await _apiServices.deleteServices(
        url: "${_api.vendorProducts}/$productId",
      );
      return response != null;
    } catch (e) {
      errorLog("VendorProductRepository deleteProduct", e);
      return false;
    }
  }

  Future<bool> updateProduct(
      int productId, Map<String, dynamic> data, List<File> images) async {
    try {
      FormData formData = FormData.fromMap(data);
      for (var file in images) {
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }

      var response = await _apiServices.patchServices(
        url: "${_api.vendorProducts}/$productId",
        body: formData,
      );

      return response != null;
    } catch (e) {
      errorLog("VendorProductRepository updateProduct", e);
      return false;
    }
  }
}
