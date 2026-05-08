
import 'package:flutter_riverpod/legacy.dart';

import 'package:nexprime/models/customer_profile_model.dart';
import 'package:nexprime/services/repository/profile_repository.dart';
import 'package:nexprime/services/storage/storage_services.dart';

import '../../../../utils/app_log.dart';

final customerProfileProvider = StateNotifierProvider<ProfileProvider,CustomerProfileModel?>((ref){
  return ProfileProvider();
});

class ProfileProvider extends StateNotifier<CustomerProfileModel?>{
  ProfileProvider():super(null){fetchProfile();}

  Future<void> fetchProfile()async{
    try{
      var role = await StorageServices.instance.getAppRoll();
      if (role.toLowerCase() == "GUEST".toLowerCase()){
        return;
      }
      final profile=await ProfileRepository.instance.profileData();
      state =profile;
    }catch(e){
      errorLog("profile Data", e);
    }
  }
}