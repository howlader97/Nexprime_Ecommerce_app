import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/services/repository/delete_account_repository.dart';
import 'package:nexprime/services/storage/storage_services.dart';
import 'package:nexprime/utils/app_snack_bar.dart';
import 'package:nexprime/widgets/loading/app_loader.dart';

Future<bool> executeDeleteAccount() async {
  AppLoader().show(message: "Deleting account...");
  try {
    final result = await DeleteAccountRepository.instance.deleteAccount();

    if (result.success) {
      if (result.message.isNotEmpty) {
        AppSnackBar.instance.success(result.message);
      }
      await StorageServices.instance.logout();
      return true;
    } else {
      if (result.message.isNotEmpty) {
        AppSnackBar.instance.error(result.message);
      }
      return false;
    }
  } catch (e) {
    AppSnackBar.instance.error(e.toString());
    return false;
  } finally {
    AppLoader().hide();
  }
}

final deleteAccountProvider = AsyncNotifierProvider<DeleteAccountNotifier, void>(
  DeleteAccountNotifier.new,
);

class DeleteAccountNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Initial state
  }

  Future<bool> deleteAccount() async {
    state = const AsyncValue.loading();
    final success = await executeDeleteAccount();
    if (success) {
      state = const AsyncValue.data(null);
    } else {
      state = AsyncValue.error("Failed to delete account", StackTrace.current);
    }
    return success;
  }
}
