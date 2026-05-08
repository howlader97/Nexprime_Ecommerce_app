import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/services/repository/auth_repository.dart';
import 'package:nexprime/services/storage/storage_services.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:nexprime/utils/app_snack_bar.dart';

final forgotResetPasswordProvider =
    StateNotifierProvider<ForgotResetPasswordProvider, bool>((ref) {
      return ForgotResetPasswordProvider();
    });

class ForgotResetPasswordProvider extends StateNotifier<bool> {
  ForgotResetPasswordProvider() : super(false);

  Future<void> resetPassword({
    required GlobalKey<FormState> formKey,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
  }) async {
    try {
      if (formKey.currentState!.validate()) {
        String password = passwordController.text.trim();
        String confirmPassword = confirmPasswordController.text.trim();

        if (password != confirmPassword) {
          AppSnackBar.instance.error(
            "Password & Confirm Password do not match",
          );
          return;
        }

        state = true;

        String token = await StorageServices.instance.getResetToken();

        bool success = await AuthRepository.instance.forgotResetPassword(
          token: token,
          newPassword: password,

        );

        state = false;

        if (success) {
          AppSnackBar.instance.success(
            "Password update successful, Login with your credential",
          );
          AppRoutes.instance.go(AppRoutesKey.instance.signInScreen);
        } else {
          AppSnackBar.instance.error("Failed to reset password. Try again.");
        }
      }
    } catch (e) {
      errorLog("resetPassword provider", e);
      state = false;
    }
  }
}
