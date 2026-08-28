import 'package:flutter/material.dart';
import 'package:nexprime/screens/vendor_screens/vendor_customer_info/widget/vendor_customer_info_text_row.dart';
import '../../../../constant/app_colors.dart';
import '../../../../models/vendor_order_model.dart';
import '../../../../utils/app_size.dart';
import '../../../../utils/gap.dart';
import '../../../../widgets/texts/app_text.dart';
import 'vendor_customer_order_action_button.dart';

class VendorCustomerInfoPaymentDetails extends StatelessWidget {
  final VendorOrderModel orderModel;
  const VendorCustomerInfoPaymentDetails({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSize.size.height * 0.02),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSize.size.height * 0.02, horizontal: AppSize.size.height * 0.02),
          decoration: BoxDecoration(color: AppColors.instance.dark50, borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(text: "Order summary", fontSize: 16, fontWeight: FontWeight.w600, height: 1.5),

              const Gap(height: 16),

              //VendorCustomerInfoTextRow(title: "Quantity: ", subTitle: '${orderModel.order.}'),
              VendorCustomerInfoTextRow(title: "Subtotal: ", subTitle: '¥${orderModel.subTotal}'),

               VendorCustomerInfoTextRow(title: "Total Shipping: ", subTitle: '¥${orderModel.totalShippingCharge}'),
              //  const VendorCustomerInfoTextRow(
              //    title: "Service charge",
              //    subTitle: '37.799 (10%)',
              //  ),
              //  const VendorCustomerInfoTextRow(title: "Tax (5%)", subTitle: '18.8995'),
              const Gap(height: 8),
              const Divider(),
              const Gap(height: 8),

              VendorCustomerInfoTextRow(title: "Total: ¥", subTitle: '${orderModel.subTotal}'),

              const Gap(height: 20),

              VendorCustomerOrderActionButton(orderModel: orderModel),
            ],
          ),
        ),
      ),
    );
  }
}
