import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/buttons/icon_button_widget.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

class CustomAppBar extends StatelessWidget {
  final VoidCallback backButton;
  final String? title;
  final String? buttonTitle;
  final VoidCallback? textButton;

  const CustomAppBar({
    super.key,
    required this.backButton,
    this.title,
    this.buttonTitle,
    this.textButton,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.size.width * 0.04,
        vertical: AppSize.size.width * 0.04,
      ),
      child: Row(
        children: [
          IconButtonWidget(
            onTap: backButton,
            icon: Icons.arrow_back,
          ),

          Gap(width: AppSize.size.width * 0.03),

          if (title != null && title!.isNotEmpty)
            Expanded(
              child: AppText(
                text: title!,
                fontSize: AppSize.size.width * 0.058,
                color: AppColors.instance.black06,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            const Spacer(),

          if (buttonTitle != null &&
              buttonTitle!.isNotEmpty &&
              textButton != null)
            AppButton(
              onTap: textButton!,
              title: buttonTitle!,
              fontSize: AppSize.size.width * 0.038,
              backgroundColor: AppColors.instance.green,
              borderColor: AppColors.instance.green,
              width: AppSize.size.width * 0.3,
              height: AppSize.size.width * 0.1,
            ),
        ],
      ),
    );
  }
}