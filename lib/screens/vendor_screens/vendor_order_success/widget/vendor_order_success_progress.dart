import 'package:flutter/material.dart';

import '../../../../constant/app_colors.dart';
import '../../../../utils/app_size.dart';
import '../../../../utils/gap.dart';
import '../../../../widgets/texts/app_text.dart';

class VendorOrderSuccessProgress extends StatelessWidget {
  final int index;

  const VendorOrderSuccessProgress({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSize.height(value: 16)),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.height(value: 12),
          horizontal: AppSize.width(value: 16),
        ),
        decoration: BoxDecoration(
          color: AppColors.instance.dark50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            /// Step Circle
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.instance.green100,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.instance.green600,
                child: AppText(
                  text: "0${index + 1}",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.instance.white500,
                ),
              ),
            ),

            SizedBox(width: AppSize.width(value: 12)),

            /// Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(text: "Order Placed", fontWeight: FontWeight.w600),
                  Gap(height: 6),
                  const AppText(text: "Oct 25, 2026", fontSize: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}