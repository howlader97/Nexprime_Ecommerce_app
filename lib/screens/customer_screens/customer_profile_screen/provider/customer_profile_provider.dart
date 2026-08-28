import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nexprime/models/customer_profile_model.dart';
import 'package:nexprime/services/repository/profile_repository.dart';
import 'package:nexprime/services/storage/storage_services.dart';

import '../../../../utils/app_log.dart';

final customerProfileProvider = AsyncNotifierProvider<ProfileProvider, CustomerProfileModel?>(ProfileProvider.new);

class ProfileProvider extends AsyncNotifier<CustomerProfileModel?> {
  @override
  Future<CustomerProfileModel?> build() async {
    return await fetchProfile();
  }

  Future<CustomerProfileModel?> fetchProfile() async {
    try {
      final role = await StorageServices.instance.getAppRoll();

      if (role.toLowerCase() == "guest") {
        return null;
      }

      return await ProfileRepository.instance.profileData();
    } catch (e) {
      errorLog("Profile Data", e);
      return null;
    }
  }

  Future<void> refreshProfile() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return await fetchProfile();
    });
  }
}


// import 'package:flutter_riverpod/legacy.dart';

// import 'package:nexprime/models/customer_profile_model.dart';
// import 'package:nexprime/services/repository/profile_repository.dart';
// import 'package:nexprime/services/storage/storage_services.dart';

// import '../../../../utils/app_log.dart';

// final customerProfileProvider = StateNotifierProvider<ProfileProvider,CustomerProfileModel?>((ref){
//   return ProfileProvider();
// });

// class ProfileProvider extends StateNotifier<CustomerProfileModel?>{
//   ProfileProvider():super(null){fetchProfile();}

//   Future<void> fetchProfile()async{
//     try{
//       var role = await StorageServices.instance.getAppRoll();
//       if (role.toLowerCase() == "GUEST".toLowerCase()){
//         return;
//       }
//       final profile=await ProfileRepository.instance.profileData();
//       state =profile;
//     }catch(e){
//       errorLog("profile Data", e);
//     }
//   }
// }