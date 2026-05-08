import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/services/repository/delivery_info_repository.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:nexprime/utils/app_snack_bar.dart';

import '../../../../routes/app_routes.dart';
import '../../../../routes/app_routes_key.dart';
import '../../customer_cart_screen/provider/cart_provider.dart';

final deliveryProvider =
    StateNotifierProvider<DeliveryProvider, AsyncValue<bool>>((ref) {
      return DeliveryProvider(ref);
    });

class DeliveryProvider extends StateNotifier<AsyncValue<bool>> {
  final Ref ref;

  DeliveryProvider(this.ref) : super(AsyncData(false));

  Future<void> getDeliveryData({
    required String name,
    required String postCode,
    required String address,
    required String roomNumber,
    required String phoneNumber,
  }) async {
    state = AsyncLoading();
    try {
      final deliveryId = await DeliveryInfoRepository.instance.deliveryInfo(
        name: name,
        postCode: postCode,
        address: address,
        roomNumber: roomNumber,
        phoneNumber: phoneNumber,
      );

      if (deliveryId != null) {
        final orderId = await DeliveryInfoRepository.instance.createOrder(
          deliveryAddressId: deliveryId.toString(),
        );

        if (orderId != null) {
          final clientSecret = await DeliveryInfoRepository.instance
              .createPaymentIntent(orderId: orderId);

          state = AsyncData(false);
          if (clientSecret != null) {
            await makePayment(clientSecret);
          } else {
            AppSnackBar.instance.error("Payment creation failed");
          }
        } else {
          state = AsyncData(false);
          AppSnackBar.instance.error("Order creation failed");
        }
      } else {
        state = AsyncData(false);
        AppSnackBar.instance.error("Data failed");
      }
    } catch (e) {
      state = AsyncData(false);
      errorLog("data failed", e);
      AppSnackBar.instance.error(e.toString());
    }
  }

  Future<void> makePayment(String clientSecret) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'NexPrime',
          paymentIntentClientSecret: clientSecret,
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      AppSnackBar.instance.success("Payment successfully completed");

      ref.read(cartProvider.notifier).clearCart();

      AppRoutes.instance.pushNamed(
        AppRoutesKey.instance.customerOrderSuccessfulScreen,
      );
    } catch (e) {
      AppSnackBar.instance.error("Payment Failed");
    }
  }
}
