
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/banner_model.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/provider/discount_product_provider.dart';
import 'package:nexprime/services/repository/home_repository.dart';
import 'package:nexprime/utils/app_log.dart';


final bannerProvider = StateNotifierProvider<BannerProvider,
    List<BannerModel>?>((ref) {
  return BannerProvider(ref);
});

class BannerProvider extends StateNotifier<List<BannerModel>?> {
  BannerProvider(this._ref) : super(null) {
    fetchBannerData();
  }

  final Ref _ref;

  Future<void> fetchBannerData() async {
    try {
      final response = await HomeRepository.instance.bannerData();
      state = response;
      _ref.read(discountProductProvider.notifier).fetchDiscountProduct();
    } catch (e) {
      errorLog("Banner Data", e);
      state = [];
    }
  }


}