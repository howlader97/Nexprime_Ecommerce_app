import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nexprime/services/repository/profile_repository.dart';
import 'package:nexprime/utils/app_snack_bar.dart';

final customerMyBalanceProvider = StateNotifierProvider<_CustomerMyBalanceProvider, AsyncValue<double>>((ref) {
  return _CustomerMyBalanceProvider(ref);
});

class _CustomerMyBalanceProvider extends StateNotifier<AsyncValue<double>> {
  final Ref ref;
  final repo = ProfileRepository.instance;

  _CustomerMyBalanceProvider(this.ref) : super(AsyncLoading()) {
    getCustomerBalance();
  }

  Future<void> getCustomerBalance() async {
    state = AsyncLoading();
    try {
      final balance = await repo.myBalance();
      state = AsyncData(balance);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> addCustomerBalance(String amount) async {
    state = AsyncLoading();
    try {
      final doubleAmount = double.tryParse(amount);
      if (doubleAmount == null || doubleAmount <= 0) {
        AppSnackBar.instance.error("Invalid amount");
        return;
      }
      final clientSecret = await repo.myBalanceTopUp(doubleAmount);
      if (clientSecret.isNotEmpty) {
        await _makeAddPayment(clientSecret);
      } else {
        AppSnackBar.instance.error("Add Balance creation failed");
      }
      final balance = await repo.myBalance();
      state = AsyncData(balance);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> _makeAddPayment(String clientSecret) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'NexPrime',
          paymentIntentClientSecret: clientSecret,
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      debugPrint("ADD BALANCE SUCCESS");
      final balance = await repo.myBalance();
      state = AsyncData(balance);

      AppSnackBar.instance.success("Add Balance successfully completed");
    } on StripeException catch (e) {
      debugPrint("STRIPE ERROR: ${e.error.localizedMessage}");
      debugPrint("STRIPE CODE: ${e.error.code}");
      AppSnackBar.instance.error(e.error.localizedMessage ?? "Add Balance Failed");
    } catch (e, s) {
      debugPrint("GENERAL ERROR: $e");
      debugPrintStack(stackTrace: s);
      AppSnackBar.instance.error("Add Balance Failed");
    }
  }
}
