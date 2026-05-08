
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/banner_model.dart';
import 'package:nexprime/services/repository/home_repository.dart';
import 'package:nexprime/utils/app_log.dart';

final bannerProvider=StateNotifierProvider<BannerProvider,List<BannerModel>>((ref){
  return BannerProvider();
});

class BannerProvider extends StateNotifier<List<BannerModel>> {
   BannerProvider(): super([]){fetchBannerData();}

  Future<void> fetchBannerData()async{
    try{
      final response= await HomeRepository.instance.bannerData();
      state =response;
    }catch(e){
      errorLog("Banner Data", e);
    }
  }
}