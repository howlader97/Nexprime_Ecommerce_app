import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/screens/vendor_screens/vendor_customer_info/widget/vendor_customer_info_details.dart';
import 'package:nexprime/screens/vendor_screens/vendor_customer_info/widget/vendor_customer_info_payment_details.dart';
import 'package:nexprime/screens/vendor_screens/vendor_customer_info/widget/vendor_customer_order_info.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/buttons/icon_button_widget.dart';
import '../vendor_order_screen/provider/vendor_order_provider.dart';

class VendorCustomerInfo extends ConsumerWidget {
  final int orderId;
  const VendorCustomerInfo({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(vendorOrderNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.width(value: 12),
            vertical: AppSize.height(value: 12),
          ),
          child: ordersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text("Error: $err")),
            data: (orders) {
              final vendorOrderModel = orders.firstWhere(
                    (o) => o.id == orderId,
                orElse: () => orders.firstWhere((o) => o.orderId == orderId),
              );

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Row(
                      children: [
                        IconButtonWidget(
                          icon: Icons.arrow_back,
                          onTap: () {
                            AppRoutes.instance.pop();
                          },
                        ),
                        Gap(width: 4),
                        AppText(
                          text: "Customer Info",
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  VendorCustomerInfoDetails(orderModel: vendorOrderModel),
                  VendorCustomerOrderInfo(orderModel: vendorOrderModel),
                  VendorCustomerInfoPaymentDetails(
                    orderModel: vendorOrderModel,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}


