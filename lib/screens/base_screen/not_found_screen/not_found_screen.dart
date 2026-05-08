import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/constant/app_constant.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppSize.size.width * 0.3),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSize.width(value: 10)),
            child: FittedBox(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSize.width(value: 5),
                children: [
                  AppText(
                    text: "404",
                    fontWeight: FontWeight.bold,
                    fontSize: AppSize.width(value: 40),
                  ),
                  AppText(
                    text: "Page Not Found!",
                    fontWeight: FontWeight.bold,
                    color: AppColors.instance.white700,
                    fontSize: AppSize.width(value: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppSize.width(value: 5),
            children: [
              AppImage(
                path: "assets/images/error.webp",
                width: AppSize.size.width * 0.8,
              ),

              Gap(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.1,
                ),
                child: AppText(
                  text:
                      "The page you requested may have been moved or no longer exists. Please return to a familiar location.",
                  textAlign: TextAlign.center,
                  fontFamily: AppConstant.instance.montserrat,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
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
              AppRoutes.instance.pop();
            },
            height: AppSize.width(value: 50),
            margin: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
            titleColor: AppColors.instance.white50,
            backgroundColor: AppColors.instance.green,
            borderColor: AppColors.instance.green,
            title: "Return to Back",
          ),
        ),
      ),
    );
  }
}
