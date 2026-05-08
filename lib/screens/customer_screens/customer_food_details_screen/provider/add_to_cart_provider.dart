import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/services/repository/cart_repository.dart';
import 'package:nexprime/utils/app_log.dart';

final addToCartProvider =
StateNotifierProvider<CartProvider, AsyncValue<bool>>((ref) {
  return CartProvider();
});

class CartProvider extends StateNotifier<AsyncValue<bool>> {
  CartProvider() : super(AsyncData(false));


  Future<void> addCartData({required int productId, int quantity = 1}) async {
    try {
      state = AsyncLoading();
      final data = await CartRepository.instance.addToCart(
          productId: productId, quantity: quantity);
      state=AsyncData(data);
    }catch(e ,st){
      errorLog("Add to Cart data", e);
      state=AsyncError(e, st);
    }
  }
}

