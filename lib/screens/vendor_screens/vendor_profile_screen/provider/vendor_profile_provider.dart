import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/vendor_store_model.dart';
import 'package:nexprime/services/repository/vendor_product_repository.dart';
import 'package:nexprime/services/repository/vendor_store_repository.dart';
import 'package:nexprime/services/storage/storage_services.dart';
import 'package:nexprime/utils/app_log.dart';

final vendorStoreProvider = StateNotifierProvider(
  (ref) => VendorStoreNotifier(),
);

class VendorStoreNotifier extends StateNotifier<AsyncValue<VendorStoreModel?>> {
  VendorStoreNotifier() : super(AsyncLoading()) {
    fetchVendorStoreData();
  }

  Future<void> fetchVendorStoreData() async {
    try {
      final role = await StorageServices.instance.getAppRoll();
      if (role.toUpperCase() != "VENDOR") {
        state = const AsyncData(null);
        return;
      }
      state = const AsyncLoading();
      final response = await VendorStoreRepository.instance
          .fetchVendorStoreData();
      state = AsyncData(response);
    } catch (e, st) {
      errorLog("VendorStoreNotifier", e);
      state = AsyncError(e, st);
    }
  }

  Future<bool> deleteProduct(int productId) async {
    final success = await VendorProductRepository.instance.deleteProduct(
      productId,
    );
    if (success) {
      await fetchVendorStoreData();
    }
    return success;
  }
}

final vendorLikesProvider =
    StateNotifierProvider.family<VendorLikesNotifier, AsyncValue<int>, int>((
      ref,
      storeId,
    ) {
      return VendorLikesNotifier(storeId);
    });

class VendorLikesNotifier extends StateNotifier<AsyncValue<int>> {
  final int storeId;
  VendorLikesNotifier(this.storeId) : super(const AsyncValue.loading()) {
    fetchLikes();
  }

  Future<void> fetchLikes() async {
    try {
      state = const AsyncValue.loading();
      final likes = await VendorStoreRepository.instance
          .fetchStoreFollowerCount(storeId);
      state = AsyncValue.data(likes ?? 0);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
