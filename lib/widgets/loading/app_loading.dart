import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/utils/app_size.dart';

Widget appLoader({double? width, double? height, Color? loaderColor}) {
  return Center(
    child: SizedBox(
      width: width ?? AppSize.width(value: 50),
      height: height ?? AppSize.width(value: 50),
      child: CircularProgressIndicator(color: loaderColor ?? AppColors.instance.primary),
    ),
  );
}
