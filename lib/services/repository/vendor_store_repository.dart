import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/models/vendor_store_model.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class VendorStoreRepository {
  /////////////// constructor
  VendorStoreRepository._privateConstructor();

  static final VendorStoreRepository _instance =
      VendorStoreRepository._privateConstructor();

  static VendorStoreRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;
  VendorStoreModel? _vendorStoreModel;

  VendorStoreModel? get vendorStoreModel => _vendorStoreModel;

  Future<VendorStoreModel?> fetchVendorStoreData() async {
    try {
      var response = await _apiServices.getServices(_api.vendorStoreMe);
      if (response != null) {
        _vendorStoreModel = VendorStoreModel.fromJson(response);
        return _vendorStoreModel;
      }
      return null;
    } catch (e) {
      errorLog("fetchVendorStoreData", e);
      return null;
    }
  }

  Future<int?> fetchStoreFollowerCount(int storeId) async {
    try {
      var response = await _apiServices.getServices(_api.storeFollowerCount(storeId));
      if (response != null) {
        return response['followerCount'] ?? 0;
      }
      return null;
    } catch (e) {
      errorLog("fetchStoreFollowerCount", e);
      return null;
    }
  }
  
}
