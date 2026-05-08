import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/constant/app_constant.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/widgets/texts/app_html_text.dart';

class BaseDataWidget extends StatelessWidget {
  const BaseDataWidget({super.key, required this.data});
  final String data;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.width(value: 20.0),
        vertical: AppSize.width(value: 20.0),
      ),
      width: AppSize.size.width,
      height: AppSize.size.height,
      decoration: BoxDecoration(color: AppColors.instance.white50),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSize.width(value: 10)),

        child: AppHtmlWidget(
          html: data,
          textStyle: TextStyle(
            fontFamily: AppConstant.instance.montserrat,
            height: 1.8,
            color: AppColors.instance.dark600,
          ),
        ),
      ),
    );
  }
}
