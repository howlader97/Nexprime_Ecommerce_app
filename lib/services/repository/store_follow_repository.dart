import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class StoreFollowRepository {
  StoreFollowRepository._privateConstructor();
  static final StoreFollowRepository _instance = StoreFollowRepository._privateConstructor();
  static StoreFollowRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<Map<String, dynamic>?> toggleFollowStore(int storeId) async {
    try {
      final response = await _apiServices.postServices(
        url: _api.followStore(storeId),
        body: {},
      );
      if (response is Map<String, dynamic>) {
        return response;
      }
    } catch (e) {
      errorLog("toggleFollowStore StoreFollowRepository", e);
    }
    return null;
  }
}
