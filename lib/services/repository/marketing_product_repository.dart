import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/models/marketing_product_model.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class MarketingProductRepository {
  /////////////// constructor
  MarketingProductRepository._privateConstructor();

  static final MarketingProductRepository _instance = MarketingProductRepository._privateConstructor();

  static MarketingProductRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;


  Future<double> getPublishFee() async {
    try {
      var response = await _apiServices.getServices(_api.publishingFee);
      if (response != null) {
        if(response is Map){
         // print(response["publishingFee"]);
          return double.tryParse("${response["publishingFee"]}") ?? 0;

        }
      }
    } catch (e) {
      errorLog("publishing fee", e);

    }
    return 0;
  }

  Future<List<MarketingProductModel>> fetchMarketingProducts({
    String? goodsType,
    String? location,
  }) async {
    try {
      final url = _api.marketingProductsFiltered(goodsType: goodsType, location: location);
      var response = await _apiServices.getServices(url);
      if (response != null && response is List) {
        return response.map((e) => MarketingProductModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      errorLog("marketing products data error", e);
      return [];
    }
  }

  Future<MarketingProductModel?> getMarketingProductById(int id) async {
    try {
      var response = await _apiServices.getServices(_api.marketingProductById(id));
      if (response != null && response is Map<String, dynamic>) {
        return MarketingProductModel.fromJson(response);
      }
      return null;
    } catch (e) {
      errorLog("getMarketingProductById error", e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> createPublishingFeePaymentIntent() async {
    try {
      var response = await _apiServices.postServices(
        url: _api.marketingProductPaymentIntent,
      );
      if (response is Map<String, dynamic>) {
        return response;
      }
    } catch (e) {
      errorLog("createPublishingFeePaymentIntent", e);
    }
    return null;
  }

  Future<bool> publishMarketingProduct(Map<String, dynamic> data, List<File> images) async {
    try {
      FormData formData = FormData.fromMap(data);
      for (var file in images) {
        formData.files.add(MapEntry(
          'images',
          await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
        ));
      }

      var response = await _apiServices.postServices(
        url: _api.marketingProducts,
        body: formData,
      );

      return response != null;
    } catch (e) {
      errorLog("publishMarketingProduct", e);
      return false;
    }
  }
  Future<bool> deleteMarketingProduct(int id) async {
    try {
      var response = await _apiServices.deleteServices(
        url: _api.deleteMarketingProduct(id),
      );
      return response != null;
    } catch (e) {
      errorLog("deleteMarketingProduct", e);
      return false;
    }
  }

  Future<bool> updateMarketingProduct(int id, Map<String, dynamic> data, List<File> images) async {
    try {
      FormData formData = FormData.fromMap(data);
      if (images.isNotEmpty) {
        for (var file in images) {
          formData.files.add(MapEntry(
            'images',
            await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
          ));
        }
      }

      var response = await _apiServices.patchServices(
        url: _api.updateMarketingProduct(id),
        body: formData,
      );

      return response != null;
    } catch (e) {
      errorLog("updateMarketingProduct", e);
      return false;
    }
  }
}
