import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/services/api/non_auth_api.dart';
import 'package:nexprime/utils/app_log.dart';

class DeliveryInfoRepository {
  /////////////// constructor
  DeliveryInfoRepository._privateConstructor();

  static final DeliveryInfoRepository _instance = DeliveryInfoRepository._privateConstructor();

  static DeliveryInfoRepository get instance => _instance;
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  NonAuthApi nonAuthApi = NonAuthApi();


  Future<int?> deliveryInfo({
    required String name,
    required String postCode,
    required String address,
    required String roomNumber,
    required String phoneNumber,
  }) async {
    try {
      Map<String, dynamic> bodyData = {
        "fullName": name,
        "postcode": postCode,
        "fullAddress": address,
        "buildingNameRoomNumber": roomNumber,
        "phoneNumber": phoneNumber,
      };

      var response = await _apiServices.postServices(
       url:  _api.deliveryInfo,
        body: bodyData,
      );

      if (response != null) {
        return response['id'];
      }else{
        return null;
      }
    } catch (e) {
      errorLog("deliveryData:", e);
    }
    return null;
  }

  Future<int?> createOrder({
    required String deliveryAddressId,
    String paymentMethod = "ONLINE",
  }) async {
    try {
      Map<String, dynamic> bodyData = {
        "deliveryAddressId": deliveryAddressId,
        "paymentMethod": paymentMethod,
      };

      var response = await _apiServices.postServices(
        url:  _api.createOrder,
        body: bodyData,
      );

      if (response != null) {
        return response['id'] as int?;
      }else{
        return null;
      }
    } catch (e) {
      errorLog("order data:", e);
    }
    return null;
  }

  Future<String?> createPaymentIntent({required int orderId}) async {
    try {
      var response = await _apiServices.postServices(
        url: _api.createPaymentIntent(orderId),
      );

      if (response != null) {
        return response['clientSecret'];
      }else{
        return null;
      }
    } catch (e) {
      errorLog("payment intent:", e);
    }
    return null;
  }
}
