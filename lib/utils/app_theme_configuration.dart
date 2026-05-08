import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/constant/app_constant.dart';


class AppThemeConfiguration {
  ////////////// constructor
  AppThemeConfiguration._privateConstructor();
  static final AppThemeConfiguration _instance =
      AppThemeConfiguration._privateConstructor();
  static AppThemeConfiguration get instance => _instance;

  ThemeData lightThemeData = ThemeData.light(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: AppColors.instance.white50,
    dividerColor: AppColors.instance.transparent,
    primaryColor: AppColors.instance.white50,
    primaryColorLight: AppColors.instance.white50,
    splashColor: AppColors.instance.transparent,
    hoverColor: AppColors.instance.transparent,
    appBarTheme: AppBarTheme(
      elevation: 5,
      surfaceTintColor: AppColors.instance.white50,
      backgroundColor: AppColors.instance.white50,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontFamily: AppConstant.instance.openSans,
        fontFamilyFallback: [
          AppConstant.instance.montserrat,
          AppConstant.instance.openSans,
        ],
      ),
      bodyMedium: TextStyle(
        fontFamily: AppConstant.instance.openSans,
        fontFamilyFallback: [
          AppConstant.instance.montserrat,
          AppConstant.instance.openSans,
        ],
      ),
      bodySmall: TextStyle(
        fontFamily: AppConstant.instance.openSans,
        fontFamilyFallback: [
          AppConstant.instance.montserrat,
          AppConstant.instance.openSans,
        ],
      ),
      displayLarge: TextStyle(
        fontFamily: AppConstant.instance.openSans,
        fontFamilyFallback: [
          AppConstant.instance.montserrat,
          AppConstant.instance.openSans,
        ],
      ),
      displayMedium: TextStyle(
        fontFamily: AppConstant.instance.openSans,
        fontFamilyFallback: [
          AppConstant.instance.montserrat,
          AppConstant.instance.openSans,
        ],
      ),
      displaySmall: TextStyle(
        fontFamily: AppConstant.instance.openSans,
        fontFamilyFallback: [
          AppConstant.instance.montserrat,
          AppConstant.instance.openSans,
        ],
      ),
      headlineLarge: TextStyle(
        fontFamily: AppConstant.instance.openSans,
        fontFamilyFallback: [
          AppConstant.instance.montserrat,
          AppConstant.instance.openSans,
        ],
      ),
      headlineMedium: TextStyle(
        fontFamily: AppConstant.instance.openSans,
        fontFamilyFallback: [
          AppConstant.instance.montserrat,
          AppConstant.instance.openSans,
        ],
      ),
      headlineSmall: TextStyle(
        fontFamily: AppConstant.instance.openSans,
        fontFamilyFallback: [
          AppConstant.instance.montserrat,
          AppConstant.instance.openSans,
        ],
      ),
      labelLarge: TextStyle(
        fontFamily: AppConstant.instance.openSans,
        fontFamilyFallback: [
          AppConstant.instance.montserrat,
          AppConstant.instance.openSans,
        ],
      ),
      labelMedium: TextStyle(
        fontFamily: AppConstant.instance.openSans,
        fontFamilyFallback: [
          AppConstant.instance.montserrat,
          AppConstant.instance.openSans,
        ],
      ),
      labelSmall: TextStyle(
        fontFamily: AppConstant.instance.openSans,
        fontFamilyFallback: [
          AppConstant.instance.montserrat,
          AppConstant.instance.openSans,
        ],
      ),
      titleLarge: TextStyle(
        fontFamily: AppConstant.instance.openSans,
        fontFamilyFallback: [
          AppConstant.instance.montserrat,
          AppConstant.instance.openSans,
        ],
      ),
      titleMedium: TextStyle(
        fontFamily: AppConstant.instance.openSans,
        fontFamilyFallback: [
          AppConstant.instance.montserrat,
          AppConstant.instance.openSans,
        ],
      ),
      titleSmall: TextStyle(
        fontFamily: AppConstant.instance.openSans,
        fontFamilyFallback: [
          AppConstant.instance.montserrat,
          AppConstant.instance.openSans,
        ],
      ),
    ),
    focusColor: AppColors.instance.blue500,

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.instance.gray200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.instance.gray200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.instance.gray200),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.instance.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.instance.error),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
        foregroundColor: AppColors.instance.white50, // text color
        backgroundColor: Colors.green,               // button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),   // avoid dynamic width here
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.instance.black900,
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),   // avoid dynamic width here
        ),
      )
    )
  );

  ThemeData darkThemeData = ThemeData.dark(useMaterial3: true);
}
