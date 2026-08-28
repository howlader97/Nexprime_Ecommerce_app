import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/screens/auth_screen/forgot_screen/screens/provider/otp_countdown_provider.dart';
import 'package:nexprime/services/repository/auth_repository.dart';
import 'package:nexprime/services/storage/storage_services.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:nexprime/utils/app_snack_bar.dart';

final forgotVerifyEmailProvider = StateNotifierProvider<ForgotVerifyEmailProvider, bool>((ref) {
  return ForgotVerifyEmailProvider(ref);
});

class ForgotVerifyEmailProvider extends StateNotifier<bool> {
  ForgotVerifyEmailProvider(this.ref) : super(false);
  final Ref ref;
  Future<void> verifyEmail({
    required GlobalKey<FormState> formKey,
    required TextEditingController otpController,
    required void Function(int index) onChange,
  }) async {
    try {
      if (formKey.currentState!.validate()) {
        state = true;

        String email = await StorageServices.instance.getEmail();
        String otp = otpController.text.trim().replaceAll(RegExp(r'\D'), '');

        String token = await AuthRepository.instance.forgotVerifyEmail(email: email, otp: otp);

        state = false;

        if (token.isNotEmpty) {
          await StorageServices.instance.setResetToken(token);
          AppSnackBar.instance.success("OTP Verification successful");
          onChange(2);
          ref.invalidate(otpCountdownProvider);
        } else {
          AppSnackBar.instance.error("Verification failed or OTP is incorrect.");
        }
      }
    } catch (e) {
      errorLog("verifyEmail provider", e);
      state = false;
    }
  }

  Future<void> resendOtp() async {
    try {
      state = true;
      String email = await StorageServices.instance.getEmail();
      bool success = await AuthRepository.instance.forgotPassword(email: email);
      state = false;
      if (success) {
        AppSnackBar.instance.success("OTP has been resent successfully");
      } else {
        AppSnackBar.instance.error("Failed to resend OTP. Please try again.");
      }
    } catch (e) {
      errorLog("resendOtp provider", e);
      state = false;
    }
  }
}
