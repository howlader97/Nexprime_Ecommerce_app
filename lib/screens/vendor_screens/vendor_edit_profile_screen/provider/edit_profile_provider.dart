import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/screens/vendor_screens/vendor_profile_screen/provider/vendor_profile_provider.dart';
import 'package:nexprime/services/repository/vendor_edit_store_repository.dart';
import 'package:nexprime/utils/app_snack_bar.dart';

final vendorEditStoreProvider = AsyncNotifierProvider<VendorEditStoreNotifier, void>(
  VendorEditStoreNotifier.new,
);

class VendorEditStoreNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Initial state is just empty data
  }

  Future<bool> updateStoreProfile({
    required String name,
    required String bio,
    required String address,
    File? photo,
    File? coverPhoto,
  }) async {
    state = const AsyncValue.loading();
    
    final success = await VendorEditStoreRepository.instance.updateStoreProfile(
      name: name,
      bio: bio,
      address: address,
      photo: photo,
      coverPhoto: coverPhoto,
    );

    if (success) {
      state = const AsyncValue.data(null);
      AppSnackBar.instance.success("Store profile updated successfully!");
      // Refresh the global store data to reflect changes immediately
      ref.read(vendorStoreProvider.notifier).fetchVendorStoreData();
      return true;
    } else {
      state = AsyncValue.error("Failed to update profile", StackTrace.current);
      return false;
    }
  }
}
