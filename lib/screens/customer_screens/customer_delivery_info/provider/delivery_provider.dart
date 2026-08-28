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
import '../../customer_order_screen/provider/customer_order_screen_provider.dart';

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
    String paymentMethod = "ONLINE", // "ONLINE" অথবা "COD"
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
          paymentMethod: paymentMethod,
        );

        if (orderId != null) {
          if (paymentMethod == "COD") {
            // COD: সরাসরি অর্ডার সফল স্ক্রিনে যাও
            state = AsyncData(false);
            AppSnackBar.instance.success("Cash on Delivery order placed successfully!");
            ref.read(cartProvider.notifier).clearCart();
            ref.invalidate(myOrderProvider);
            AppRoutes.instance.pushNamed(
              AppRoutesKey.instance.customerOrderSuccessfulScreen,
            );
          } else {
            // ONLINE: Stripe payment flow
            final clientSecret = await DeliveryInfoRepository.instance
                .createPaymentIntent(orderId: orderId);

            state = AsyncData(false);
            if (clientSecret != null) {
              await makePayment(clientSecret);
            } else {
              AppSnackBar.instance.error("Payment creation failed");
            }
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

      debugPrint("PAYMENT SUCCESS");

      AppSnackBar.instance.success("Payment successfully completed");

      ref.read(cartProvider.notifier).clearCart();
      ref.invalidate(myOrderProvider);

      AppRoutes.instance.pushNamed(
        AppRoutesKey.instance.customerOrderSuccessfulScreen,
      );
    } on StripeException catch (e) {
      debugPrint("STRIPE ERROR: ${e.error.localizedMessage}");
      debugPrint("STRIPE CODE: ${e.error.code}");

      AppSnackBar.instance.error(
        e.error.localizedMessage ?? "Payment Failed",
      );
    } catch (e, s) {
      debugPrint("GENERAL ERROR: $e");
      debugPrintStack(stackTrace: s);

      AppSnackBar.instance.error("Payment Failed");
    }
  }
}
