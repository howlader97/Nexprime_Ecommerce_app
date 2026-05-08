import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/product_model.dart';
import 'package:nexprime/services/repository/product_repository.dart';
import 'package:nexprime/utils/app_log.dart';

final productSearchProvider =
    StateNotifierProvider<ProductSearchProvider, AsyncValue<List<ProductModel>>>((ref) {
  return ProductSearchProvider();
});

class ProductSearchProvider extends StateNotifier<AsyncValue<List<ProductModel>>> {
  ProductSearchProvider() : super(const AsyncData([]));

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncData([]);
      return;
    }

    state = const AsyncLoading();
    try {
      final products = await ProductRepository.instance.searchProduct(query);
      state = AsyncData(products);
    } catch (e, stack) {
      errorLog("search product provider", e);
      state = AsyncError(e, stack);
    }
  }
}
