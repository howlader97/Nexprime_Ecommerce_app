import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/models/static_page_model.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class StaticPageRepository {
  StaticPageRepository._privateConstructor();

  static final StaticPageRepository _instance =
      StaticPageRepository._privateConstructor();

  static StaticPageRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<List<StaticPageModel>?> fetchStaticPages() async {
    try {
      var response = await _apiServices.getServices(_api.staticPages);
      if (response != null && response is List) {
        return StaticPageModel.fromJsonList(response);
      }
      return null;
    } catch (e) {
      errorLog("fetchStaticPages", e);
      return null;
    }
  }
}
