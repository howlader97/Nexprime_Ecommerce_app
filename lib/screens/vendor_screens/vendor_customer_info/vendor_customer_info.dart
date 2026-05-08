import 'package:flutter/material.dart';
import 'package:nexprime/screens/vendor_screens/vendor_customer_info/widget/vendor_customer_info_details.dart';
import 'package:nexprime/screens/vendor_screens/vendor_customer_info/widget/vendor_customer_info_payment_details.dart';
import 'package:nexprime/screens/vendor_screens/vendor_customer_info/widget/vendor_customer_order_info.dart';
import '../../../utils/app_size.dart';
import '../vendor_product_screen/widgets/vendor_product_app_bar.dart';

class VendorCustomerInfo extends StatelessWidget {
  const VendorCustomerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.width(value: 12),
            vertical: AppSize.height(value: 12),
          ),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: VendorAppBar(title: "Customer Info"),
              ),
              VendorCustomerInfoDetails(),
              VendorCustomerOrderInfo(),
              VendorCustomerInfoPayementDetails(),
            ],
          ),
        ),
      ),
    );
  }
}

