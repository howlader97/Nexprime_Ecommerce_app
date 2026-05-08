// import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/screens/base_screen/faq_screen/models/f_a_q_screen_data_model.dart';
// import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class BaseRepository {
  /////////////// constructor
  BaseRepository._privateConstructor();
  static final BaseRepository _instance = BaseRepository._privateConstructor();
  static BaseRepository get instance => _instance;

  /////////////// object
  // final ApiServices _apiServices = ApiServices.instance;
  // final AppApiUrl _api = AppApiUrl.instance;

  //////////////// function
  Future<String> termsAndConditions() async {
    try {
      /////////// wait for backend
      // var response = await _apiServices.getServices(_api.termsAndConditions);
      // if (response != null) {
      //   if (response["data"] != null && response["data"] is Map) {
      //     var data = response["data"];
      //     if (data["content"] != null && data["content"] is String) {
      //       return data["content"].toString()
      //         ..replaceAll('white-space:pre-wrap;', '')
      //             .replaceAll('\u00A0', ' ')
      //             .replaceAll(RegExp(r'\s+'), ' ')
      //             .trim();
      //     }
      //   }
      // }
      return """Under the Specified Commercial Transactions Act (特定商取引法), OmniMarket provides complete transparency regarding product availability, pricing, and refund policies. Our team works closely with Japanese regulators to ensure all transactions are secure and compliant.Under the Specified Commercial Transactions Act (特定商取引法), OmniMarket provides complete transparency regarding product availability, pricing, and refund policies. Our team works closely with Japanese regulators to ensure all transactions are secure and compliant.Under the Specified Commercial Transactions Act (特定商取引法), OmniMarket provides complete transparency regarding product availability, pricing, and refund policies. Our team works closely with Japanese regulators to ensure all transactions are secure and compliant.""";
    } catch (e) {
      errorLog("termsAndConditions repo", e);
    }
    return "";
  }

  Future<String> aboutUs() async {
    try {
      ////////////  wait for backend
      // var response = await _apiServices.getServices(_api.about);
      // if (response != null) {
      //   if (response["data"] != null && response["data"] is Map) {
      //     var data = response["data"];
      //     if (data["content"] != null && data["content"] is String) {
      //       return data["content"].toString()
      //         ..replaceAll('white-space:pre-wrap;', '')
      //             .replaceAll('\u00A0', ' ')
      //             .replaceAll(RegExp(r'\s+'), ' ')
      //             .trim();
      //     }
      //   }
      // }
      return """Under the Specified Commercial Transactions Act (特定商取引法), OmniMarket provides complete transparency regarding product availability, pricing, and refund policies. Our team works closely with Japanese regulators to ensure all transactions are secure and compliant.Under the Specified Commercial Transactions Act (特定商取引法), OmniMarket provides complete transparency regarding product availability, pricing, and refund policies. Our team works closely with Japanese regulators to ensure all transactions are secure and compliant.Under the Specified Commercial Transactions Act (特定商取引法), OmniMarket provides complete transparency regarding product availability, pricing, and refund policies. Our team works closely with Japanese regulators to ensure all transactions are secure and compliant.""";
    } catch (e) {
      errorLog("aboutUs repo", e);
    }
    return "";
  }

  Future<String> privacyPolicy() async {
    try {
      ///////  wait for backend
      // var response = await _apiServices.getServices(_api.privacyPolicy);
      // if (response != null) {
      //   if (response["data"] != null && response["data"] is Map) {
      //     var data = response["data"];
      //     if (data["content"] != null && data["content"] is String) {
      //       return data["content"].toString()
      //         ..replaceAll('white-space:pre-wrap;', '')
      //             .replaceAll('\u00A0', ' ')
      //             .replaceAll(RegExp(r'\s+'), ' ')
      //             .trim();
      //     }
      //   }
      // }
      return """Under the Specified Commercial Transactions Act (特定商取引法), OmniMarket provides complete transparency regarding product availability, pricing, and refund policies. Our team works closely with Japanese regulators to ensure all transactions are secure and compliant.Under the Specified Commercial Transactions Act (特定商取引法), OmniMarket provides complete transparency regarding product availability, pricing, and refund policies. Our team works closely with Japanese regulators to ensure all transactions are secure and compliant.Under the Specified Commercial Transactions Act (特定商取引法), OmniMarket provides complete transparency regarding product availability, pricing, and refund policies. Our team works closely with Japanese regulators to ensure all transactions are secure and compliant.""";
    } catch (e) {
      errorLog("privacyPolicy repo", e);
    }
    return "";
  }

  Future<List<FAQScreenDataModel>> getAllFaq() async {
    List<FAQScreenDataModel> listOfFaqData = [];
    try {
      /////////////// wait for backend
      // var response = await _apiServices.getServices(_api.faq);
      // if (response != null) {
      //   if (response["data"] is List) {
      //     for (var element in response["data"]) {
      //       listOfFaqData.add(FAQScreenDataModel.fromJson(element));
      //     }
      //   }
      // }

      listOfFaqData = [
        FAQScreenDataModel(
          title: "Do I need an account to place an order?",
          body:
              "You can browse as a guest, but you need to create an account to place an order so we can track your delivery and save your preferences.",
        ),
        FAQScreenDataModel(
          title: "Do I need an account to place an order?",
          body:
              "You can browse as a guest, but you need to create an account to place an order so we can track your delivery and save your preferences.",
        ),
        FAQScreenDataModel(
          title: "Do I need an account to place an order?",
          body:
              "You can browse as a guest, but you need to create an account to place an order so we can track your delivery and save your preferences.",
        ),
        FAQScreenDataModel(
          title: "Do I need an account to place an order?",
          body:
              "You can browse as a guest, but you need to create an account to place an order so we can track your delivery and save your preferences.",
        ),
        FAQScreenDataModel(
          title: "Do I need an account to place an order?",
          body:
              "You can browse as a guest, but you need to create an account to place an order so we can track your delivery and save your preferences.",
        ),
        FAQScreenDataModel(
          title: "Do I need an account to place an order?",
          body:
              "You can browse as a guest, but you need to create an account to place an order so we can track your delivery and save your preferences.",
        ),
        FAQScreenDataModel(
          title: "Do I need an account to place an order?",
          body:
              "You can browse as a guest, but you need to create an account to place an order so we can track your delivery and save your preferences.",
        ),
        FAQScreenDataModel(
          title: "Do I need an account to place an order?",
          body:
              "You can browse as a guest, but you need to create an account to place an order so we can track your delivery and save your preferences.",
        ),
        FAQScreenDataModel(
          title: "Do I need an account to place an order?",
          body:
              "You can browse as a guest, but you need to create an account to place an order so we can track your delivery and save your preferences.",
        ),
      ];
    } catch (e) {
      errorLog("getAllFaq", e);
    }
    return listOfFaqData;
  }
}
