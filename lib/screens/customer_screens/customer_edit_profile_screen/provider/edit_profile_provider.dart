import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/screens/customer_screens/customer_new_product_list/provider/marketplace_location_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_profile_screen/provider/customer_profile_provider.dart';
import 'package:nexprime/services/repository/customer_repository.dart';
import 'package:nexprime/utils/app_log.dart';

final editProfileProvider =
    StateNotifierProvider<EditProfileProvider, AsyncValue<bool>>((ref) {
      return EditProfileProvider(ref);
    });

class EditProfileProvider extends StateNotifier<AsyncValue<bool>> {
  final Ref ref;
  EditProfileProvider(this.ref) : super(const AsyncValue.data(false));

  Future<void> updateProfile({
    required Map<String, dynamic> body,
    String? profileImagePath,
    String? coverImagePath,
  }) async {
    state = const AsyncValue.loading();

    try {
      final success = await CustomerEditProfileRepository.instance.updateProfile(
        body: body,
        profileImagePath: profileImagePath,
        coverImagePath: coverImagePath,
      );

      if (success) {

        await ref.read(customerProfileProvider.notifier).refreshProfile();

        ref.invalidate(marketPlaceLocationProvider);
      }

      state = AsyncValue.data(success);
    } catch (e, st) {
      errorLog("update profile provider error", e);
      state = AsyncValue.error(e, st);
    }
  }
}
