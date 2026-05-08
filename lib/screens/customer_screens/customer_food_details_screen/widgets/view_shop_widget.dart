import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../../../utils/app_size.dart';

class ViewShopWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String image;

  const ViewShopWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.width(value: 13)),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppSize.width(value: 15)),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          SizedBox(
            width: AppSize.size.width * 0.12,
            height: AppSize.size.height * 0.055,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AppImage(
                isZomBle: true,
                url: image,
                fit: BoxFit.cover,
                // fit: BoxFit.cover,
              ),
            ),
          ),
          Gap(width: AppSize.size.width * 0.02),
          Expanded(
            child: AppText(
              text: title,
              fontWeight: FontWeight.bold,
              fontSize: AppSize.size.width * 0.048,
            ),
          ),
          AppButton(
          //  height: AppSize.size.height * 0.05,
            title: "View Shop",
            fontSize: AppSize.size.width * 0.044,
            padding: EdgeInsets.all(AppSize.size.width * 0.015),
            fontWeight: FontWeight.w500,
            titleColor: AppColors.instance.black06,
            onTap: onTap,
            backgroundColor: AppColors.instance.white50,
            borderColor: AppColors.instance.black06,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}
