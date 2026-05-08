import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/cart_model.dart';
import 'package:nexprime/services/repository/cart_repository.dart';
import 'package:nexprime/services/storage/storage_services.dart';

final cartProvider =
    StateNotifierProvider<CartProvider, AsyncValue<CartModel?>>((ref) {
      return CartProvider();
    });

class CartProvider extends StateNotifier<AsyncValue<CartModel?>> {
  CartProvider() : super(const AsyncValue.loading()) {
    getCartData();
  }

  Future<void> getCartData() async {
    try {
      var role = await StorageServices.instance.getAppRoll();
      if (role.toLowerCase() == "GUEST".toLowerCase()) {
        return;
      }
      state = const AsyncValue.loading();
      final cart = await CartRepository.instance.getCart();
      state = AsyncValue.data(cart);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void clearCart() {
    state = const AsyncValue.data(null);
  }

  Future<void> updateQuantity(int cartItemId, String action) async {
    final success = await CartRepository.instance.updateCartQuantity(
      cartItemId: cartItemId,
      action: action,
    );
    if (success) {
      try {
        final cart = await CartRepository.instance.getCart();
        state = AsyncValue.data(cart);
      } catch (e) {
        // Silently fail or keep current state if refresh fails
      }
    }
  }
}
