import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constant/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../../../../routes/app_routes_key.dart';
import '../../../../utils/app_size.dart';
import '../../../../utils/gap.dart';
import '../../../../widgets/texts/app_text.dart';
import '../provider/discount_product_provider.dart';

class ShowDialogWidget extends ConsumerWidget {
  const ShowDialogWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discountProduct = ref.watch(discountProductProvider);

    if (discountProduct == null) {
      return const SizedBox.shrink();
    }

    return AlertDialog(
      backgroundColor: Colors.white.withValues(alpha: 0.3),
      //insetPadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(10),
      titlePadding: EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
      title: Row(
        children: [
          const AppText(text: "Discount Product", color: Colors.white),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
      content: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          if (discountProduct.size.isNotEmpty || discountProduct.colors.isNotEmpty) {
            AppRoutes.instance.pushNamed(AppRoutesKey.instance.customerClothDetailsScreen, extra: discountProduct);
          } else {
            AppRoutes.instance.pushNamed(AppRoutesKey.instance.customerFoodDetailsScreen, extra: discountProduct);
          }
        },
        child: DecoratedBox(
          decoration: BoxDecoration(color: AppColors.instance.grayEE, borderRadius: BorderRadius.circular(20)),
          child: SizedBox(
            width: AppSize.size.width * 0.4,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: AppSize.size.width * 0.22,
                      width: AppSize.size.width,
                      child: Image.network(discountProduct.images.isNotEmpty ? discountProduct.images.first : '', fit: BoxFit.cover),
                    ),
                  ),
                  Gap(height: AppSize.size.width * 0.02),
                  AppText(
                    text: discountProduct.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    fontSize: AppSize.size.width * 0.04,
                    fontWeight: FontWeight.w500,
                    color: AppColors.instance.black06,
                  ),
                  Row(
                    children: [
                      AppText(
                        text: "¥${discountProduct.salePrice.toStringAsFixed(1)}",
                        fontSize: AppSize.size.width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: AppColors.instance.black06,
                      ),
                      SizedBox(width: AppSize.size.width * 0.014),
                      AppText(
                        text: "¥${discountProduct.basePrice.toStringAsFixed(1)}",
                        fontSize: AppSize.size.width * 0.035,
                        fontWeight: FontWeight.w400,
                        color: AppColors.instance.redF7,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
