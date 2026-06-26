import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/buttons/icon_button_widget.dart';
import 'package:nexprime/widgets/texts/app_text.dart';


class ProductCartWidget extends StatelessWidget {
  final String image;
  final bool isFeatures;
  final String itemTitle;
  final String price;
  final String? discountPrice;
  final VoidCallback? onTap;
  final VoidCallback? onPressed;

  const ProductCartWidget({super.key,
    this.isFeatures = false,
    required this.image,
    required this.itemTitle,
    required this.price,
    this.discountPrice,
    this.onTap,
    this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.instance.grayEE,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          width: AppSize.size.width * 0.45,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: AppSize.size.width * 0.19,
                    width: AppSize.size.width,
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Gap(height: AppSize.size.height * 0.0018),
                AppText(
                  text: itemTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: AppSize.size.width * 0.044,
                  fontWeight: FontWeight.w500,
                  color: AppColors.instance.black06,
                ),
                if (!isFeatures) ...[
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          text: "\$$price",
                          fontSize: AppSize.size.width * 0.044,
                          fontWeight: FontWeight.w600,
                          color: AppColors.instance.black06,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Gap(width:3),
                      if(discountPrice != null)  Expanded(
                        child: AppText(
                          text: "\$${discountPrice ?? ''}",
                          fontSize: AppSize.size.width * 0.032,
                          fontWeight: FontWeight.w400,
                          color: AppColors.instance.redF7,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],),
                  // Gap(height: AppSize.size.height * 0.005),
                  AppButton(
                    onTap: onTap,
                    backgroundColor: AppColors.instance.green,
                    borderColor: AppColors.instance.green,
                    title: "Add To Cart",
                    fontSize: 16,
                    height: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          text:   price,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          fontSize: AppSize.size.width * 0.045,
                          fontWeight: FontWeight.w600,
                          color: AppColors.instance.black06,
                        ),
                      ),
                      // Gap(width: AppSize.size.width * 0.12),

                      IconButtonWidget(
                        onTap: onPressed,
                        padding: AppSize.size.width * 0.010,
                        icon: Icons.add,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}