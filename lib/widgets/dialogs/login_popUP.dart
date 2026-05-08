import 'package:flutter/material.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../constant/app_colors.dart';

void callLoginDialog(){
  try{
    var context = rootNavigatorKey.currentContext;
    if(context == null) return;
    showDialog(context: context, builder: (context) {
      return LoginPopup();
    },);
  }catch(_){}
}
class LoginPopup extends StatelessWidget {
  const LoginPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),

      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:  Center(
          child: AppText( text: 
            "Need to Login",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:AppColors.instance.black06,
              fontSize: 18,
            ),
          ),
        ),
      ),
      content:  AppText( text: 
        "Please login to continue.",style: TextStyle(
        color:AppColors.instance.black06,
      ),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      contentPadding: EdgeInsets.symmetric(vertical: 12),
      actions: [

        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child:  AppText( text: 
            "Cancel",
            style: TextStyle(color:AppColors.instance.black06,fontSize: 16),
          ),
        ),
        GestureDetector(
          onTap: () {
            AppRoutes.instance.go(AppRoutesKey.instance.signInScreen);
          },
          child:  AppText( text: "Login",style: TextStyle(color:AppColors.instance.black06,fontSize: 16),),
        ),
      ],
    );
  }
}