import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/services/repository/product_repository.dart';
import 'package:nexprime/utils/app_log.dart';

import '../../../../models/product_model.dart';

final productProvider =
    StateNotifierProvider.family<
      ProductProvider,
      AsyncValue<List<ProductModel>>,
      int
    >((ref, id) {
      return ProductProvider(id);
    });

class ProductProvider extends StateNotifier<AsyncValue<List<ProductModel>>> {
  final int id;
  
  int? currentShopId;
  int? currentCategoryId;
  String? currentSize;

  ProductProvider(this.id) : super(AsyncLoading()) {
    getProduct();
  }

  Future<void> getProduct({
    int? shopId,
    int? categoryId,
    String? size,
    bool clearShop = false,
    bool clearCategory = false,
    bool clearSize = false,
  }) async {
    if (clearShop) {
      currentShopId = null;
    } else if (shopId != null) {
      currentShopId = shopId;
    }

    if (clearCategory) {
      currentCategoryId = null;
    } else if (categoryId != null) {
      currentCategoryId = categoryId;
    }

    if (clearSize) {
      currentSize = null;
    } else if (size != null) {
      currentSize = size;
    }

    state = AsyncValue.loading();
    try {
      final product = await ProductRepository.instance.fetchProduct(
        id,
        shopId: currentShopId,
        categoryId: currentCategoryId,
        size: currentSize,
      );
      state = AsyncData(product);
    } catch (e) {
      errorLog("product is", e);
    }
  }
}
