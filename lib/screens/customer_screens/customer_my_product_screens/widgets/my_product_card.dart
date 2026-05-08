import 'package:flutter/material.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../../../constant/app_asserts_icons_path.dart';
import '../../../../constant/app_colors.dart';
import '../../../../utils/app_size.dart';
import '../../../../widgets/app_image/app_image.dart';
import '../../../../widgets/buttons/app_button.dart';

class MyProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final bool marketplace;

  const MyProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.onEdit,
    this.onDelete,
    this.marketplace = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.instance.grayEE,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSize.width(value: 10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AppImage(
                height: AppSize.size.width * 0.22,
                width: AppSize.size.width,
                url: imageUrl,
              ),
            ),
            //  Gap(height: AppSize.size.width * 0.012),
            Spacer(),
            AppText(
              text: title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              fontSize: AppSize.size.width * 0.042,
              color: AppColors.instance.black06,
              fontWeight: FontWeight.w500,
            ),
            Gap(height: AppSize.size.width * 0.012),
            // Spacer(),
            AppText(
              text: price,
              fontSize: AppSize.size.width * 0.05,
              color: AppColors.instance.black06,
              fontWeight: FontWeight.w600,
            ),
            Spacer(),
            marketplace
                ? AppButton(
                    onTap: onTap,
                    height: AppSize.size.width * 0.09,
                    backgroundColor: AppColors.instance.green,
                    borderColor: AppColors.instance.green,
                    title: "View Details",
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton(
                        onTap: onEdit,
                        backgroundColor: AppColors.instance.green,
                        borderColor: AppColors.instance.green,
                        child: AppImage(
                          height: AppSize.size.width * 0.055,
                          width: AppSize.size.width * 0.061,
                          path: AppAssertsIconsPath.instance.editIcon,
                        ),
                      ),
                      Gap(width: AppSize.size.width * 0.03),
                      AppButton(
                        onTap: onDelete,
                        backgroundColor: AppColors.instance.transparent,
                        child: Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
