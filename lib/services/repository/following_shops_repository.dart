import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/models/follow_store_model.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class FollowingShopsRepository {
  FollowingShopsRepository._privateConstructor();

  static final FollowingShopsRepository _instance =
  FollowingShopsRepository._privateConstructor();

  static FollowingShopsRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<List<FollowStoreModel>> followingShop() async {
    List<FollowStoreModel> listOfData = [];
    try {
      var response = await _apiServices.getServices(_api.followStores);
      if ( response is List) {
        for(var item in response){
          listOfData.add(FollowStoreModel.fromJson(item));
        }
      }

    } catch (e) {
      errorLog("followShop", e);

    }
    return listOfData;
  }
}
