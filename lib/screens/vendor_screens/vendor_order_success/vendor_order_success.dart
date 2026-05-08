import 'package:flutter/material.dart';
import 'package:nexprime/screens/vendor_screens/vendor_order_success/widget/vendor_order_success_progress.dart';
import 'package:nexprime/screens/vendor_screens/vendor_order_success/widget/vendor_order_success_top.dart';
import 'package:nexprime/screens/vendor_screens/vendor_product_screen/widgets/vendor_product_app_bar.dart';
import 'package:nexprime/utils/app_size.dart';

class VendorOrderSuccess extends StatelessWidget {
  const VendorOrderSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.height(value: 16),
            horizontal: AppSize.width(value: 16),
          ),
          child: CustomScrollView(
            slivers: [
              /// App Bar
              SliverToBoxAdapter(child: VendorAppBar(title: "Track Order")),

              /// Top Section
              SliverToBoxAdapter(child: VendorOrderSuccessTop()),

              /// Progress List
              SliverList.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return VendorOrderSuccessProgress(index: index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
