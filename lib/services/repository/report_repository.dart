import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/services/api/non_auth_api.dart';
import 'package:nexprime/services/storage/storage_services.dart';
import 'package:nexprime/utils/app_log.dart';

class ReportRepository {
  ////////////// Contractures
  ReportRepository._privetContractures();

  static final ReportRepository _instance =
      ReportRepository._privetContractures();

  static ReportRepository get instance => _instance;

  /////////////// object
  ApiServices apiServices = ApiServices.instance;
  NonAuthApi nonAuthApi = NonAuthApi();
  AppApiUrl api = AppApiUrl.instance;
  StorageServices storageServices = StorageServices.instance;

  Future<Map<String, dynamic>?> reportData({
    required int reporterUserId,
    required int targetUserId,
    required int productId,
    required String content,
  }) async {
    try {
      Map<String, dynamic> body = {
        "reporterUserId": reporterUserId,
        "targetUserId": targetUserId,
        "marketingProductId": productId,
        "content": content,
      };

      var response = await apiServices.postServices(
        url: api.report,
        body: body,
      );

      if (response != null) {
        return response;
      }
    } catch (e) {
      errorLog("Report error", e);
    }
    return null;
  }
}
