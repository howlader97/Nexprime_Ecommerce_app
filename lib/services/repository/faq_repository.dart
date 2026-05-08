import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/models/faq_model.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class FaqRepository {
  /////////////// constructor
  FaqRepository._privateConstructor();

  static final FaqRepository _instance =
      FaqRepository._privateConstructor();

  static FaqRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<List<FaqModel>?> fetchFaqs() async {
    try {
      var response = await _apiServices.getServices(_api.faqs);
      if (response != null && response is List) {
        return FaqModel.fromJsonList(response);
      }
      return null;
    } catch (e) {
      errorLog("fetchFaqs", e);
      return null;
    }
  }
}
