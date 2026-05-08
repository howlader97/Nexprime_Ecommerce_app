import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/models/shop_details_model.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class StoreRepository {
  StoreRepository._privateConstructor();

  static final StoreRepository _instance =
      StoreRepository._privateConstructor();

  static StoreRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<StoreDetailsModel?> fetchStoreData(int storeId) async {
    try {
      final response = await _apiServices.getServices(_api.viewShop(storeId));
      if (response is Map<String, dynamic>) {
        return StoreDetailsModel.fromJson(response);
      }
    } catch (e) {
      errorLog("store data", e);
    }
    return null;
  }
}
