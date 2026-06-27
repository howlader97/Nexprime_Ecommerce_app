import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/models/vendor_seven_days_dashboard_model.dart';
import 'package:nexprime/models/vendor_today_dashborad_model.dart';
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

  Future<dynamic> dashboardData({String? filterType, String? startDate, String? endDate}) async {
    try {
      String url = _api.vendorDashboard;
      List<String> queryParams = [];
      if (filterType != null && filterType.isNotEmpty) {
        queryParams.add("filter_type=$filterType");
      }
      if (filterType == 'custom') {
        if (startDate != null && startDate.isNotEmpty) {
          queryParams.add("start_date=$startDate");
        }
        if (endDate != null && endDate.isNotEmpty) {
          queryParams.add("end_date=$endDate");
        }
      }
      if (queryParams.isNotEmpty) {
        url = "$url?${queryParams.join('&')}";
      }
      var response = await _apiServices.getServices(url);

      if (response != null && response is Map<String, dynamic>) {
        if (filterType == 'today' || filterType == 'yesterday') {
          return VendorTodayDashboardModel.fromJson(response);
        } else {
          return VendorSevenDaysDashboardModel.fromJson(response);
        }
      }

      return null;
    } catch (e) {
      errorLog("vendor dashboard data", e);
      return null;
    }
  }
}