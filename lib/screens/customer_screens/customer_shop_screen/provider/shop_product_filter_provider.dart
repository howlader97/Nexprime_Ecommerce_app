import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../models/product_model.dart';
import '../../../../services/repository/shop_product_filter_repository.dart';

final groceryFilterProvider = StateNotifierProvider.family<ShopProductFilterNotifier, AsyncValue<List<ProductModel>?>, int>((ref, shopId) {
  return ShopProductFilterNotifier(shopId);
});

final wardrobeFilterProvider = StateNotifierProvider.family<ShopProductFilterNotifier, AsyncValue<List<ProductModel>?>, int>((ref, shopId) {
  return ShopProductFilterNotifier(shopId);
});

class ShopProductFilterNotifier extends StateNotifier<AsyncValue<List<ProductModel>?>> {
  final int shopId;
  ShopProductFilterNotifier(this.shopId) : super(const AsyncValue.data(null));

  int? selectedCategoryId;

  Future<void> filterProducts(int? categoryId) async {
    selectedCategoryId = categoryId;
    if (categoryId == null) {
      state = const AsyncValue.data(null);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final products = await ShopProductFilterRepository.instance.fetchFilteredProducts(
        shopId: shopId,
        subcategoryIds: categoryId,
      );
      state = AsyncValue.data(products);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
