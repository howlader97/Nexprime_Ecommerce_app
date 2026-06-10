import 'package:flutter/material.dart';
import 'package:nexprime/models/vendor_order_model.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';

import '../../../../constant/app_colors.dart';
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
        padding: EdgeInsets.only(
            top: AppSize.size.height * 0.01
        ),
        child: Column(
          children: List.generate(
            orderModel.orderItems.length,
                (index){
              String? productName=orderModel.orderItems[index].product?.name;
              String? productImage = (orderModel.orderItems[index].product?.images != null &&
                  orderModel.orderItems[index].product!.images.isNotEmpty)
                  ? orderModel.orderItems[index].product!.images[0]
                  : null;
              int? quantity=orderModel.orderItems[index].quantity;
              double? price=orderModel.order?.totalAmount;

              final bool isNetwork = productImage != null &&
                  (productImage.startsWith('http://') || productImage.startsWith('https://'));

              return Container(
                margin: EdgeInsets.only(bottom: AppSize.size.height * 0.01),
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
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: AppImage(
                        url: isNetwork ? productImage : null,
                        path: !isNetwork ? (productImage ?? "assets/dev_image/food_image.png") : null,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Gap(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: productName??"Crispy Delights",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),

                          const Gap(height: 6),

                          AppText(
                            text:
                            "Product Quantity: ${quantity??0}",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const Gap(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text: "\$${price??0}",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                              ),
                              //IconButtonWidget(icon: Icons.add),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}