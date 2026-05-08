import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/models/vendor_dashboard_model.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class VendorDashboardRepository {
  /////////////// constructor
  VendorDashboardRepository._privateConstructor();

  static final VendorDashboardRepository _instance =
  VendorDashboardRepository._privateConstructor();

  static VendorDashboardRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<VendorDashboardModel?> dashboardData() async {
    try {
      var response = await _apiServices.getServices(_api.vendorDashboard);

      if (response != null && response is Map<String, dynamic>) {
        return VendorDashboardModel.fromJson(response);
      }

      return null;
    } catch (e) {
      errorLog("vendor dashboard data", e);
      return null;
    }
  }
}