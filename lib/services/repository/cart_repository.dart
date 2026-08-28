import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/models/cart_model.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class CartRepository {
  CartRepository._privateConstructor();
  static final CartRepository _instance = CartRepository._privateConstructor();
  static CartRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<CartModel?> getCart() async {
    try {
      final response = await _apiServices.getServices(_api.addToCart);

      if (response != null) {
        return CartModel.fromJson(response);
      }
      return null;
    } catch (e) {
      errorLog("get cart error", e);
      return null;
    }
  }

  Future<bool> updateCartQuantity({required int cartItemId, required String action}) async {
    try {
      final body = {"action": action};

      final response = await _apiServices.patchServices(url: _api.cartQuantity(cartItemId), body: body);

      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      errorLog("update cart error", e);
      return false;
    }
  }

  Future<bool> addToCart({required int productId, int quantity = 1, String? size, String? color}) async {
    try {
      Map<String, dynamic> body = {"productId": productId, "quantity": quantity};
      if (size != null) body["size"] = size;
      if (color != null) body["color"] = color;

      final response = await _apiServices.postServices(url: _api.addToCart, body: body);

      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      errorLog("add to cart error", e);
      return false;
    }
  }
}
