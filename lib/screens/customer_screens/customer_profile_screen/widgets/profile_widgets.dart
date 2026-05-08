import 'package:flutter/material.dart';
import '../../../../constant/app_colors.dart';
import '../../../../utils/app_size.dart';
import '../../../../utils/gap.dart';
import '../../../../widgets/texts/app_text.dart';

class ProfileWidget extends StatelessWidget {
  final Widget child;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const ProfileWidget({
    super.key,
    required this.child,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.instance.grayEE,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.size.width * 0.04,
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.instance.grayE5,
                  borderRadius: BorderRadius.circular(6),

                ),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: child,
                  ),
                ),
              ),
              Gap(width: AppSize.size.width * 0.03),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: title,
                      fontSize: 18,
                      color: AppColors.instance.black06,
                      fontWeight: FontWeight.w600,
                    ),
                   if(subtitle != null) AppText(
                      text: subtitle ?? '',
                      fontSize: 14,
                      color: AppColors.instance.black06,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
             // Icon(Icons.arrow_forward, color: AppColors.instance.black06),
            ],
          ),
        ),
      ),
    );
  }
}