import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/widgets/buttons/icon_button_widget.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

class CustomLocationWidget extends StatelessWidget {
  final String location;
  const CustomLocationWidget({
    super.key, required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      child: Row(
        children: [
          IconButtonWidget(icon: Icons.location_on_outlined),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText( text: 
                  "Deliver to",
                  style: TextStyle(
                    fontSize: AppSize.size.width * 0.035,
                    color: AppColors.instance.black400,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                AppText( text: 
                  location,
                  style: TextStyle(
                    fontSize: AppSize.size.width * 0.04,
                    color: AppColors.instance.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}