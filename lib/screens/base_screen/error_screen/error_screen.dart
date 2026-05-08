import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/constant/app_constant.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppSize.width(value: 5),
            children: [
              AppImage(path: "assets/images/not_found.webp"),
              Gap(height: 10),
              AppText(
                text: "Something went wrong",
                fontSize: AppSize.width(value: 25),
                fontFamily: AppConstant.instance.montserrat,
                fontWeight: FontWeight.w500,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.2,
                ),
                child: AppText(
                  text:
                      "We encountered an error while trying to connect with our server.",
                  textAlign: TextAlign.center,
                  height: 1.5,
                ),
              ),
              Gap(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.2,
                ),
                child: AppText(
                  text: "Please try after some time.😓",
                  textAlign: TextAlign.center,
                  height: 1.5,
                  fontFamily: AppConstant.instance.montserrat,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: AppSize.width(value: 40)),
          child: AppButton(
            onTap: () {
              AppRoutes.instance.go(AppRoutesKey.instance.initial);
            },
            height: AppSize.width(value: 50),
            margin: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
            backgroundColor: AppColors.instance.green,
            borderColor: AppColors.instance.green,
            title: "Return to Home",
          ),
        ),
      ),
    );
  }
}
