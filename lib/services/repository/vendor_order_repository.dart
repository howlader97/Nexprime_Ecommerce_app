import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/models/vendor_order_model.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class VendorOrderRepository {
  VendorOrderRepository._privateConstructor();
  static final VendorOrderRepository _instance =
  VendorOrderRepository._privateConstructor();
  static VendorOrderRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<List<VendorOrderModel>> fetchVendorOrders() async {
    try {
      var response = await _apiServices.getServices(_api.vendorOrdersMe);
      if (response != null && response is List) {
        return response.map((x) => VendorOrderModel.fromJson(x)).toList();
      }
      return [];
    } catch (e) {
      errorLog("VendorOrderRepository fetchVendorOrders", e);
      return [];
    }
  }

  Future<bool> archiveSubOrder(int id, bool isArchive) async {
    try {
      var response = await _apiServices.patchServices(
        url: "${_api.archiveSubOrder(id)}?is_archive=$isArchive",
      );
      return response != null;
    } catch (e) {
      errorLog("VendorOrderRepository archiveSubOrder", e);
      return false;
    }
  }

  Future<bool> completeSubOrder(int id, bool isComplete) async {
    try {
      var response = await _apiServices.patchServices(
        url: "${_api.completeSubOrder(id)}?is_complete=$isComplete",
      );
      return response != null;
    } catch (e) {
      errorLog("VendorOrderRepository completeSubOrder", e);
      return false;
    }
  }

  Future<bool> fulfillSubOrder(
      int id,
      bool isFulfill, {
        String? trackingNumber,
        String? courierName,
      }) async {
    try {
      final body = isFulfill
          ? {
        "trackingNumber": trackingNumber ?? "",
        "courierName": courierName ?? "Japan Post",
      }
          : null;

      var response = await _apiServices.patchServices(
        url: isFulfill
            ? _api.fulfillSubOrder(id)
            : "${_api.fulfillSubOrder(id)}?is_fulfield=false",
        body: body,
      );
      return response != null;
    } catch (e) {
      errorLog("VendorOrderRepository fulfillSubOrder", e);
      return false;
    }
  }

}
