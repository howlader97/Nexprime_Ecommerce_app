import 'package:flutter/material.dart';
import 'package:nexprime/screens/vendor_screens/vendor_customer_info/widget/vendor_customer_info_text_row.dart';
import '../../../../constant/app_colors.dart';
import '../../../../utils/app_size.dart';
import '../../../../utils/gap.dart';
import '../../../../widgets/texts/app_text.dart';
import 'vendor_customer_order_action_button.dart';

class VendorCustomerInfoPayementDetails extends StatelessWidget {
  const VendorCustomerInfoPayementDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSize.size.height * 0.02),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.size.height * 0.02,
            horizontal: AppSize.size.height * 0.02,
          ),
          decoration: BoxDecoration(
            color: AppColors.instance.dark50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              AppText(
                text: "Order summary",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),

              Gap(height: 16),

              VendorCustomerInfoTextRow(title: "Quantity", subTitle: '1x'),
              VendorCustomerInfoTextRow(
                title: "Subtotal",
                subTitle: '\$377.99',
              ),
              VendorCustomerInfoTextRow(title: "Shipping", subTitle: 'Free'),
              VendorCustomerInfoTextRow(
                title: "Service charge",
                subTitle: '37.799 (10%)',
              ),
              VendorCustomerInfoTextRow(title: "Tax (5%)", subTitle: '18.8995'),

              Gap(height: 8),
              Divider(),
              Gap(height: 8),

              VendorCustomerInfoTextRow(title: "Total", subTitle: '396.8895'),

              Gap(height: 20),

              VendorCustomerOrderActionButton(),
            ],
          ),
        ),
      ),
    );
  }
}
