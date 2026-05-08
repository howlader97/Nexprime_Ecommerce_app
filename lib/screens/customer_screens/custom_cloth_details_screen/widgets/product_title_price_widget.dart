import 'package:flutter/material.dart';
import '../../../../constant/app_colors.dart';
import '../../../../utils/app_size.dart';
import '../../../../utils/gap.dart';
import '../../../../widgets/texts/app_text.dart';

class ProductTitlePriceWidget extends StatelessWidget {
  final String productName;
  final String price;
  const ProductTitlePriceWidget({
    super.key,
   required this.productName, required this.price,
  });



  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: "Clothing",
              fontSize: AppSize.size.width * 0.035,
              color: AppColors.instance.gray400,
            ),
            Gap(height: AppSize.size.width * 0.015),
            AppText(
              text: productName,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ],
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.instance.green,
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSize.size.width * 0.022),
            child: AppText(
              text: price,
              fontSize: AppSize.size.width * 0.046,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}