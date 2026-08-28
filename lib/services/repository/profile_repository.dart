import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/models/customer_profile_model.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class ProfileRepository {
  /////////////// constructor
  ProfileRepository._privateConstructor();

  static final ProfileRepository _instance = ProfileRepository._privateConstructor();

  static ProfileRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;
  CustomerProfileModel? _customerProfileModel;

  CustomerProfileModel? get customerProfileModel => _customerProfileModel;

  Future<CustomerProfileModel?> profileData() async {
    try {
      var response = await _apiServices.getServices(_api.customerProfile);
      if (response != null) {
        _customerProfileModel = CustomerProfileModel.fromJson(response);
        return _customerProfileModel;
      }
      return null;
    } catch (e) {
      errorLog("profile data", e);
      return null;
    }
  }

  Future<double> myBalance() async {
    try {
      var response = await _apiServices.getServices(_api.myBalance);
      if (response is Map) {
        return double.tryParse(response["balance"].toString()) ?? 0.0;
      }
    } catch (e) {
      errorLog("my balance", e);
    }
    return 0.0;
  }

  Future<String> myBalanceTopUp(double amount) async {
    try {
      var response = await _apiServices.postServices(url: _api.myBalanceTopUp, body: {"amount": amount});
      if (response is Map) {
        if (response.containsKey("clientSecret") && response["clientSecret"] is String) {
          return response["clientSecret"].toString();
        }
      }
    } catch (e) {
      errorLog("my balance", e);
    }
    return "";
  }
}
