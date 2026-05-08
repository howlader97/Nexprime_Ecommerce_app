import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/screens/customer_screens/customer_order_screen/widgets/order_card.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';

import '../../../routes/app_routes.dart';

class CustomerOrderScreen extends StatelessWidget {
  const CustomerOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                vertical: AppSize.size.height * 0.02,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  OrderCard(
                    date: "25/01/26",
                    orderId: "#ORD-1001",
                    status: "Shipped",
                    productName: "Kent Ozone Vegetable and Fru...",
                    productImageUrl:
                        "https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=150&q=80",
                  ),
                  Gap(height: AppSize.size.height * 0.02),

                  OrderCard(
                    onPressed: () {
                      AppRoutes.instance.pushNamed(
                        AppRoutesKey.instance.customerReviewScreen,
                      );
                    },
                    date: "25/01/26",
                    orderId: "#ORD-1001",
                    status: "Delivered",
                    productName: "Kent Ozone Vegetable and Fru...",
                    productImageUrl:
                        "https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=150&q=80",
                    isDelivered: true,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
