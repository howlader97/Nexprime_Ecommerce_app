import 'package:dio/dio.dart';
import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/models/my_order_list_model.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

import '../../utils/app_snack_bar.dart';

class OrderRepository {
  OrderRepository._privateConstructor();
  static final OrderRepository _instance = OrderRepository._privateConstructor();
  static OrderRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;


  Future<List<MyOrderListModel>> myAllOrder() async {
    try {
      final response = await _apiServices.getServices(_api.myOrder);

      if (response != null) {
         if(response is List){
           return response.map((e) => MyOrderListModel.fromJson(e as Map<String, dynamic>)).toList();
         }
      }
    } catch (e) {
      errorLog("myAllOrder error", e);
    }
    return [];
  }

  Future<bool> review({
    required int score,
    required String reviewText,
    required int id,
  }) async {
    try {
      var response = await _apiServices.api.sendRequest.post(
        _api.orderRatings(id),
        data: {
          "score": score,
          "review": reviewText,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map) {
        if (e.response?.data["detail"] != null) {
          AppSnackBar.instance.error("${e.response?.data["detail"]}");
        } else if (e.response?.data["message"] != null) {
          AppSnackBar.instance.error("${e.response?.data["message"]}");
        }
      }
      errorLog("customer review repo", e);
    } catch (e) {
      errorLog("customer review repo", e);
    }
    return false;
  }

  Future<bool> confirmOrderReceipt(int subOrderId) async {
    try {
      var response = await _apiServices.api.sendRequest.patch(
        "/orders/sub-order/$subOrderId/confirm-receipt",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map) {
        if (e.response?.data["detail"] != null) {
          AppSnackBar.instance.error("${e.response?.data["detail"]}");
        }
      }
      errorLog("confirmOrderReceipt error", e);
    } catch (e) {
      errorLog("confirmOrderReceipt error", e);
    }
    return false;
  }
}
