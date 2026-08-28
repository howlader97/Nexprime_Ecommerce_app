import 'package:flutter/material.dart';
import '../../../../widgets/app_image/app_image.dart';

import '../../../../constant/app_colors.dart';
import '../../../../models/vendor_order_model.dart';
import '../../../../utils/app_size.dart';
import '../../../../utils/gap.dart';
import '../../../../widgets/texts/app_text.dart';

class VendorCustomerOrderInfo extends StatelessWidget {
  final VendorOrderModel orderModel;
  const VendorCustomerOrderInfo({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: AppSize.size.height * 0.01),
        child: Column(
          children: List.generate(orderModel.orderItems.length, (index) {
            final orderItem = orderModel.orderItems[index];
            String? productName = orderItem.product?.name;
            String? productImage = (orderItem.product?.images != null && orderItem.product!.images.isNotEmpty) ? orderItem.product!.images[0] : null;
            int? quantity = orderItem.quantity;
            double? price = orderItem.price;
            String? size = orderItem.size;
            String? color = orderItem.color;

            final bool isNetwork = productImage != null && (productImage.startsWith('http://') || productImage.startsWith('https://'));

            return Container(
              margin: EdgeInsets.only(bottom: AppSize.size.height * 0.01),
              padding: EdgeInsets.symmetric(vertical: AppSize.size.height * 0.01, horizontal: AppSize.size.height * 0.01),
              decoration: BoxDecoration(color: AppColors.instance.dark50, borderRadius: BorderRadius.circular(8)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
                    clipBehavior: Clip.antiAlias,
                    child: AppImage(
                      url: isNetwork ? productImage : "",
                      path: !isNetwork ? (productImage ?? "assets/dev_image/food_image.png") : "",
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Gap(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        AppText(text: productName ?? "Crispy Delights", fontSize: 16, fontWeight: FontWeight.w600, height: 1.5),

                        const Gap(height: 5),

                        Row(
                          children: [
                            AppText(
                              text: "Product Quantity: ${quantity ?? 0}",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              height: 1.5,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Gap(width: 10,),
                            AppText(
                              text: "Tax Fee: ${orderItem.product?.taxFee} %",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.green,
                              height: 1.5,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),

                        if (size != null || color != null) ...[
                          const Gap(height: 5),
                          Row(
                            children: [
                              if (size != null) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
                                  child: Text("Size: $size", style: TextStyle(fontSize: 13, color: Colors.black)),
                                ),
                                const Gap(width: 8),
                              ],
                              if (color != null) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
                                  child: Text("Color: $color", style: TextStyle(fontSize: 13, color: Colors.black)),
                                ),
                              ],
                            ],
                          ),
                        ],

                        const Gap(height: 5),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(text: "¥${price ?? 0.0}", fontSize: 16, fontWeight: FontWeight.w600, height: 1.5),
                            //IconButtonWidget(icon: Icons.add),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
