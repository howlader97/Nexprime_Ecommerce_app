import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/models/product_model.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class ShopProductFilterRepository {
  ShopProductFilterRepository._privateConstructor();

  static final ShopProductFilterRepository _instance =
  ShopProductFilterRepository._privateConstructor();

  static ShopProductFilterRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<List<ProductModel>> fetchFilteredProducts({
    required int shopId,
    required int subcategoryIds,
  }) async {
    List<ProductModel> productData = [];
    try {
      final url = _api.filterProductsByShopAndSubcategory(
        shopId: shopId,
        subcategoryIds: subcategoryIds,
      );
      final response = await _apiServices.getServices(url);
      if (response is List) {
        for (var item in response) {
          productData.add(ProductModel.fromJson(item));
        }
      }
    } catch (e) {
      errorLog("filtered products data error", e);
    }
    return productData;
  }
}
