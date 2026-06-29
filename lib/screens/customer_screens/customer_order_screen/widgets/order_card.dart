import 'package:flutter/material.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';

import '../../../../constant/app_colors.dart';
import '../../../../utils/app_size.dart';
import '../../../../utils/gap.dart';
import '../../../../widgets/app_image/app_image.dart';
import '../../../../widgets/buttons/app_button.dart';
import '../../../../widgets/buttons/custom_decorated_box.dart';
import '../../../../widgets/texts/app_text.dart';

class OrderCard extends StatelessWidget {
  final String date;
  final String orderId;
  final String status;
  final String productName;
  final bool isTrackOrderOpen;
  final bool isReviewSectionOpen;
  final String productImageUrl;
  final String? trackingUrl;
  final VoidCallback? onTap;
  final VoidCallback? onPressed;
  final String? size;
  final String? color;
  final String? shopName;

  const OrderCard({
    super.key,
    required this.date,
    required this.orderId,
    required this.status,
    required this.productName,
    required this.productImageUrl,
    this.onTap,
    this.onPressed,
    required this.isTrackOrderOpen,
    required this.isReviewSectionOpen,
    this.trackingUrl,
    this.size,
    this.color,
    this.shopName,
  });

  @override
  Widget build(BuildContext context) {
    // print("isReviewSectionOpen: $isReviewSectionOpen");
    // print("isTrackOrderOpen $isTrackOrderOpen");
    return CustomDecoratedBox(
      child: Padding(
        padding: EdgeInsets.all(AppSize.size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: date,
                      fontSize: AppSize.size.width * 0.035,
                      color: AppColors.instance.gray400,
                    ),
                    Gap(height: AppSize.size.width * 0.011),
                    AppText(
                      text: orderId,
                      fontSize: AppSize.size.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: (status.toLowerCase() == 'shipped' || status.toLowerCase() == 'delivered')
                        ? AppColors.instance.green
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: (status.toLowerCase() == 'shipped' || status.toLowerCase() == 'delivered')
                        ? null
                        : Border.all(color: Colors.grey.shade400),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(AppSize.size.width * 0.03),
                    child: AppText(
                      text: status,
                      color: (status.toLowerCase() == 'shipped' || status.toLowerCase() == 'delivered')
                          ? Colors.white
                          : Colors.grey.shade700,
                      fontSize: AppSize.size.width * 0.033,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Gap(height: AppSize.size.width * 0.024),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: AppImage(url: productImageUrl, fit: BoxFit.cover),
                ),
                Gap(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: productName,
                        fontSize: AppSize.size.width * 0.042,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                      ),
                      if (size != null || color != null) ...[
                        const Gap(height: 4),
                        Row(
                          children: [
                            if (size != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "Size: $size",
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                                ),
                              ),
                              const Gap(width: 8),
                            ],
                            if (color != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "Color: $color",
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                      if (shopName != null) ...[
                        const Gap(height: 4),
                        AppText(
                          text: "Shop: $shopName",
                          fontSize: 12,
                          color: AppColors.instance.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                      if (isTrackOrderOpen) ...[
                        const Gap(height: 2.8),
                        GestureDetector(
                          onTap: () {
                            AppRoutes.instance.pushNamed(
                              AppRoutesKey.instance.customerOrderTrackList,
                              extra: trackingUrl ?? '',
                            );
                          },
                          child: AppText(
                            text: "Track Order",
                            fontSize: AppSize.size.width * 0.042,
                            color: AppColors.instance.green,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.instance.green,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (isReviewSectionOpen) ...[
              Gap(height: 16),
              AppButton(
                title: "Give Feedback",
                backgroundColor: Colors.transparent,
                borderColor: Colors.grey.shade400,
                titleColor: AppColors.instance.black500,
                onTap: onPressed,
                height: AppSize.size.height * 0.052,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
