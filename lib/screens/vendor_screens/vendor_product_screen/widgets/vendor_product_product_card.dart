import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import '../../../../widgets/app_image/app_image.dart';

class VendorProductProductCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String oldPrice;
  final String stock;
  final String image;
  final VoidCallback? edit;
  final VoidCallback? delete;

  const VendorProductProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.stock,
    required this.image,
    this.edit,
    this.delete,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.instance.dark50,
        borderRadius: BorderRadius.circular(AppSize.width(value: 10)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.size.height * 0.009,
          horizontal: AppSize.size.width * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            /// Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.width(value: 4)),
              child: AppImage(
                path: image.startsWith('http') ? null : image,
                url: image.startsWith('http') ? image : null,
                height: AppSize.size.width * 0.21,
                width: AppSize.size.width,
                fit: BoxFit.cover,
              ),
            ),
            //    Gap(height: 8,),
            AppText(
              text: title,
              fontWeight: FontWeight.w600,
              fontSize: AppSize.width(value: 16),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            // Gap(height: 4),
            AppText(
              text:description,
              fontSize: AppSize.width(value: 12),
              color: AppColors.instance.gray300,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),

            //  Gap(height: 5),

            SizedBox(
              width: AppSize.size.width,
              height: AppSize.size.width * 0.06,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    AppText(
                      text: price,
                      fontWeight: FontWeight.w600,
                      fontSize: AppSize.size.width * 0.05,
                      height: 1,
                      maxLines: 1,
                    ),
                    if (oldPrice.isNotEmpty) ...[
                      Gap(width: 12),
                      AppText(
                        textAlign: TextAlign.center,
                        text: oldPrice,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.red,
                        fontSize: AppSize.size.width * 0.05,
                        decorationColor: Colors.red,
                        maxLines: 1,
                      ),
                    ],
                    Gap(width: 16),
                    AppText(
                      textAlign: TextAlign.end,
                      text: stock,
                      color: AppColors.instance.redF7,
                      fontWeight: FontWeight.w600,
                      fontSize: AppSize.size.width * 0.05,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),

            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSize.width(value: 5)),
                  decoration: BoxDecoration(
                    color: AppColors.instance.green,
                    borderRadius: BorderRadius.circular(
                      AppSize.width(value: 6),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: edit,
                    child: Icon(
                      Icons.edit,
                      size: AppSize.width(value: 16),
                      color: AppColors.instance.white50,
                    ),
                  ),
                ),
                Gap(width: 10),
                Container(
                  padding: EdgeInsets.all(AppSize.width(value: 4)),
                  decoration: BoxDecoration(
                    color: AppColors.instance.dark50,
                    borderRadius: BorderRadius.circular(
                      AppSize.width(value: 6),
                    ),
                    border: Border.all(
                      color: AppColors.instance.black700,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: delete,
                    child: Icon(
                      Icons.delete_outline_outlined,
                      size: AppSize.width(value: 16),
                      color: AppColors.instance.black400,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
