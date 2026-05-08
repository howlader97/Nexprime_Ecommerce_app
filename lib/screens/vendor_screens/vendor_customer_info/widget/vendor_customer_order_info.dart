import 'package:flutter/material.dart';

import '../../../../constant/app_colors.dart';
import '../../../../utils/app_size.dart';
import '../../../../utils/gap.dart';
import '../../../../widgets/buttons/icon_button_widget.dart';
import '../../../../widgets/texts/app_text.dart';

class VendorCustomerOrderInfo extends StatelessWidget {
  const VendorCustomerOrderInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          top: AppSize.size.height * 0.01
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.size.height * 0.01,
            horizontal: AppSize.size.height * 0.01,
          ),
          decoration: BoxDecoration(
            color: AppColors.instance.dark50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/dev_image/food_image.png",
                height: AppSize.height(value: 100),
                fit: BoxFit.cover,
              ),
              const Gap(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      text: "Crispy Delights",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),

                    const Gap(height: 6),

                    const AppText(
                      text:
                      "Lightly battered and deep-fried jumbo shrimps served with a warm dipping sauce.",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Gap(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        AppText(
                          text: "\$300",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                        IconButtonWidget(icon: Icons.add),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}