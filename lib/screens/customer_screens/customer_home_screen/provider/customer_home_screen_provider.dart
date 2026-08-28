import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nexprime/models/banner_model.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/provider/discount_product_provider.dart';
import 'package:nexprime/services/repository/home_repository.dart';
import 'package:nexprime/utils/app_log.dart';

final bannerProvider = AsyncNotifierProvider<BannerProvider, List<BannerModel>>(BannerProvider.new);

class BannerProvider extends AsyncNotifier<List<BannerModel>> {
  @override
  Future<List<BannerModel>> build() async {
    return await _fetchBannerData();
  }

  Future<List<BannerModel>> _fetchBannerData() async {
    try {
      final response = await HomeRepository.instance.bannerData();

      // Trigger the next provider after banners are loaded.
      Future.microtask(() {
        ref.read(discountProductProvider.notifier).fetchDiscountProduct();
      });

      return response;
    } catch (e) {
      errorLog("Banner Data", e);
      return [];
    }
  }

  Future<void> refreshBanner() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return await _fetchBannerData();
    });
  }
}

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:nexprime/models/banner_model.dart';
// import 'package:nexprime/screens/customer_screens/customer_home_screen/provider/discount_product_provider.dart';
// import 'package:nexprime/services/repository/home_repository.dart';
// import 'package:nexprime/utils/app_log.dart';

// final bannerProvider = StateNotifierProvider<BannerProvider, List<BannerModel>?>((ref) {
//   return BannerProvider(ref);
// });

// class BannerProvider extends StateNotifier<List<BannerModel>?> {
//   BannerProvider(this._ref) : super(null) {
//     fetchBannerData();
//   }

//   final Ref _ref;

//   Future<void> fetchBannerData() async {
//     try {
//       await Future.delayed(const Duration(seconds: 10));
//       final response = await HomeRepository.instance.bannerData();
//       state = response;
//       _ref.read(discountProductProvider.notifier).fetchDiscountProduct();
//     } catch (e) {
//       errorLog("Banner Data", e);
//       state = [];
//     }
//   }
// }
