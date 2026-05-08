import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/models/marketing_product_model.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class MyMarketingProductRepository {
  /////////////// constructor
  MyMarketingProductRepository._privateConstructor();

  static final MyMarketingProductRepository _instance = MyMarketingProductRepository._privateConstructor();

  static MyMarketingProductRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<List<MarketingProductModel>> fetchMyMarketingProducts() async {
    try {
      var response = await _apiServices.getServices(_api.myMarketingProducts);
      if (response != null && response is List) {
        return response.map((e) => MarketingProductModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      errorLog("my marketing products data error", e);
      return [];
    }
  }
}
