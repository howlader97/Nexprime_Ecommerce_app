import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/models/customer_profile_model.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class ProfileRepository {
  /////////////// constructor
  ProfileRepository._privateConstructor();

  static final ProfileRepository _instance =
      ProfileRepository._privateConstructor();

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
}
