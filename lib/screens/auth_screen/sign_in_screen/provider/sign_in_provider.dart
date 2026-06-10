import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/screens/customer_screens/customer_profile_screen/provider/customer_profile_provider.dart';
import 'package:nexprime/screens/vendor_screens/vendor_profile_screen/provider/vendor_profile_provider.dart';
import 'package:nexprime/services/repository/auth_repository.dart';
import 'package:nexprime/utils/app_log.dart';

import '../../../vendor_screens/vendor_home_screen/provider/vendor_home_screen_provider.dart';
import '../../../vendor_screens/vendor_order_screen/provider/vendor_order_provider.dart';

final signInProvider=StateNotifierProvider<_SignInProvider,bool>((ref){
  return _SignInProvider(ref);

});

 class _SignInProvider extends StateNotifier<bool>{
   _SignInProvider(this._ref):super(false);
   final Ref _ref;

   Future signIn(String email,String password)async{

     try{
       state =true;
       final response= await AuthRepository.instance.login(
           email: email, password: password);
       _ref.invalidate(customerProfileProvider);
       _ref.invalidate(vendorStoreProvider);
       _ref.invalidate(vendorOrderNotifierProvider);
       _ref.invalidate(vendorDashboard);
       state=false;
       return response;
     }catch(e){
       errorLog("Login", e);
       state = false;
       return false;
     }
   }

 }