import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/product_model.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/widgets/show_dialog_widget.dart';
import 'package:nexprime/services/repository/home_repository.dart';
import 'package:nexprime/services/storage/storage_services.dart';
import 'package:nexprime/utils/app_log.dart';

final discountProductProvider = StateNotifierProvider<DiscountProductProvider, ProductModel?>((ref) {
  return DiscountProductProvider();
});

class DiscountProductProvider extends StateNotifier<ProductModel?> {
  DiscountProductProvider() : super(null);

  Future<void> fetchDiscountProduct() async {
    try {
      var appRoll = await StorageServices.instance.getAppRoll();
      if (appRoll.toLowerCase() == "guest") {
        return;
      }

      final discountProductResult = await HomeRepository.instance.discountProduct();
      if (!mounted) return;
      state = discountProductResult;
      
      if (state != null) {
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          var context = rootNavigatorKey.currentContext;
          if (context == null) return;
          showDialog(
            context: context,
            builder: (context) {
              return const ShowDialogWidget();
            },
          );
        });
      }
    } catch (e) {
      errorLog("Discount Product Data", e);
      if (mounted) {
        state = null;
      }
    }
  }
}
