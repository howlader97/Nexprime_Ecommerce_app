import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/main_app_entry.dart';
import 'package:nexprime/widgets/texts/app_date_time_formate.dart';

Future<void> main() async {
  //////////////  flutter binding initialize
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = "pk_test_51TioGt721aYTGBGeF7WMRV6PhrXvZpLcZ8mQ2jXqEShwJU11eOUlHjAsrBsHJKW4woD1V0R5fEoBlRR5nLSXTfLU00Rn2TNYcP";

  await Stripe.instance.applySettings();

  ///////////// devices orientation set
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  //////////// app navigation style set
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.instance.transparent,
      statusBarColor: AppColors.instance.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  ////////////// network
  HttpOverrides.global = MyHttpOverrides();

  runApp( MainAppEntry());
  ////////// time formate
  await AppDateTimeFormate.instance.initial();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
