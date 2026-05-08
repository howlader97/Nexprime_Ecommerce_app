import 'package:flutter/material.dart';

import '../../../../constant/app_colors.dart';
import '../../../../utils/gap.dart';
import '../../../../widgets/texts/app_text.dart';

class VendorProfileRating extends StatelessWidget {
  final Function() onTap;

  const VendorProfileRating({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 28),
          const Gap(width: 6),
          const AppText(text: "4.5", fontWeight: FontWeight.w600),
          const Gap(width: 4),
          AppText(
            text: "(120 reviews)",
            fontSize: 12,
            color: AppColors.instance.gray300,
          ),
          const Gap(width: 10),
          AppText(
            text: "2 Products",
            fontSize: 12,
            color: AppColors.instance.gray300,
          ),
        ],
      ),
    );
  }
}
