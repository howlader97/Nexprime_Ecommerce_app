import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/utils/app_log.dart';

import '../../../../models/shop_details_model.dart';
import '../../../../services/repository/store_repository.dart';
import '../../../../services/repository/store_follow_repository.dart';

final customerShopProvider = StateNotifierProvider.family<ShopDetails, AsyncValue<StoreDetailsModel?>, int>((ref, storeId) {
  return ShopDetails(storeId);
});

class ShopDetails extends StateNotifier<AsyncValue<StoreDetailsModel?>>{
  final int id;
  ShopDetails(this.id):super(AsyncLoading()){getStoreData();}

  Future<void> getStoreData()async{
    state=AsyncLoading();
    try{
      final response = await StoreRepository.instance.fetchStoreData(id);
      state=AsyncData(response);
    }catch(e){
      errorLog("Store data", e);
    }
  }

  Future<void> toggleFollow() async {
    final currentStore = state.value;
    if (currentStore == null) return;

    final newIsFollowing = !currentStore.isFollowing;
    final newFollowerCount = newIsFollowing
        ? currentStore.followerCount + 1
        : currentStore.followerCount - 1;

    state = AsyncData(currentStore.copyWith(
      isFollowing: newIsFollowing,
      followerCount: newFollowerCount,
    ));

    try {
      final response = await StoreFollowRepository.instance.toggleFollowStore(id);
      if (response == null || response['following'] == null) {
        state = AsyncData(currentStore);
      } else {
        final actualFollowing = response['following'] as bool;
        if (actualFollowing != newIsFollowing) {
          state = AsyncData(currentStore.copyWith(
            isFollowing: actualFollowing,
            followerCount: actualFollowing ? currentStore.followerCount + 1 : currentStore.followerCount - 1,
          ));
        }
      }
    } catch (e) {
      errorLog("Toggle follow error", e);
      state = AsyncData(currentStore); // Revert
    }
  }
}