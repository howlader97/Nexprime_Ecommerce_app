import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/models/product_model.dart';
import 'package:nexprime/models/review_model.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class ProductRepository {
  /////////////// constructor
  ProductRepository._privateConstructor();

  static final ProductRepository _instance =
      ProductRepository._privateConstructor();

  static ProductRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<List<ProductModel>> fetchProduct(
    int id, {
    int? shopId,
    int? categoryId,
    String? size,
  }) async {
    List<ProductModel> productData = [];
    try {
      final response = await _apiServices.getServices(
        _api.filterProducts(
          id,
          shopId: shopId,
          categoryId: categoryId,
          size: size,
        ),
      );
      if (response is List) {
        for (var item in response) {
          productData.add(ProductModel.fromJson(item));
        }
      }
    } catch (e) {
      errorLog("product data", e);
    }
    return productData;
  }

  Future<List<ProductModel>> searchProduct(String query) async {
    List<ProductModel> productData = [];
    try {
      final response = await _apiServices.getServices(
        _api.searchProducts(query),
      );
      if (response is List) {
        for (var item in response) {
          productData.add(ProductModel.fromJson(item));
        }
      }
    } catch (e) {
      errorLog("search product data", e);
    }
    return productData;
  }

  Future<List<ReviewModel>> fetchReview(int productId) async {
    List<ReviewModel> reviewData = [];
    try {
      final response = await _apiServices.getServices(_api.review(productId));
      if (response is List) {
        for (var item in response) {
          reviewData.add(ReviewModel.fromJson(item));
        }
      }
    } catch (e) {
      errorLog("product data", e);
    }
    return reviewData;
  }
}
