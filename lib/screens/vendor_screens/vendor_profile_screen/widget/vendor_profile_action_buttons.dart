import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import 'vendor_more_options_dialog.dart';

class VendorProfileActionButtons extends StatelessWidget {
  const VendorProfileActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton.icon(
            onPressed: () async {
              AppRoutes.instance.pushNamed(AppRoutesKey.instance.customerMessageScreen);
            },
            icon: Icon(Icons.chat_bubble_outline_rounded, size: 18, color: AppColors.instance.green),
            label: AppText(
              text: "Message",
              style: TextStyle(color: AppColors.instance.green, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.instance.green, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          const Gap(width: 12),
          OutlinedButton.icon(
            onPressed: () {
              showVendorMoreOptionsDialog(context);
            },
            icon: Icon(Icons.more_horiz_rounded, size: 20, color: AppColors.instance.green),
            label: AppText(
              text: "More",
              style: TextStyle(color: AppColors.instance.green, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.instance.green, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}
