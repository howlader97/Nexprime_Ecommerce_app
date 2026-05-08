import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/follow_store_model.dart';
import 'package:nexprime/services/repository/following_shops_repository.dart';
import 'package:nexprime/utils/app_log.dart';

final shopListProvider= StateNotifierProvider<ShopList,AsyncValue<List<FollowStoreModel>>>((ref){
  return ShopList();
});

class ShopList extends StateNotifier<AsyncValue<List<FollowStoreModel>>> {
  ShopList():super(AsyncLoading()){getShopList();}

  Future<void> getShopList()async{
    try{
      state= AsyncValue.loading();
      final response= await FollowingShopsRepository.instance.followingShop();
      state=AsyncData(response);
    }catch(e){
      errorLog("shop data", e);
    }
  }
}