import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_asserts_image_path.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/screens/customer_screens/customer_cloth_checkout_screen/widgets/widget_row.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/buttons/icon_button_widget.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import '../../../constant/app_colors.dart';
import '../../../widgets/buttons/custom_decorated_box.dart';

class CustomerClothCheckoutScreen extends StatelessWidget {
  const CustomerClothCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  IconButtonWidget(
                    onTap: () {
                      AppRoutes.instance.pop();
                    },
                    icon: Icons.arrow_back,
                  ),
                  const SizedBox(width: 6),
                  AppText(text: "Checkout", fontSize: AppSize.size.width * 0.055, color: AppColors.instance.black06, fontWeight: FontWeight.w600),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: CustomDecoratedBox(
                height: AppSize.size.height * 0.18,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AppImage(
                          width: AppSize.size.width * 0.43,
                          url: "https://www.yellowclothing.net/cdn/shop/files/DSC0004288_16.jpg?v=1771044529",
                        ),
                      ),
                      Gap(width: AppSize.size.width * 0.028),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: "Huddie's",
                              fontSize: AppSize.size.width * 0.047,
                              color: AppColors.instance.black06,
                              fontWeight: FontWeight.w600,
                              // ),
                            ),
                            Gap(height: AppSize.size.height * 0.007),
                            AppText(
                              text: "Lightly battered and deep-fried jumbo shrimps served with a warm dipping sauce.",
                              maxLines: 2,
                              fontSize: AppSize.size.width * 0.04,
                              overflow: TextOverflow.ellipsis,
                              color: AppColors.instance.black06,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(height: AppSize.size.height * 0.04),
                            Row(
                              children: [
                                AppText(
                                  text: "¥188.87",
                                  fontSize: AppSize.size.width * 0.047,
                                  color: AppColors.instance.black06,
                                  fontWeight: FontWeight.w600,
                                ),
                                SizedBox(width: AppSize.size.height * 0.06),
                                IconButtonWidget(icon: Icons.add),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CustomDecoratedBox(
                child: Padding(
                  padding: EdgeInsets.all(AppSize.size.width * 0.03),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AppImage(path: AppAssertsImagePath.instance.homeImage, height: AppSize.size.height * 0.09, fit: BoxFit.cover),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: "Delivery Address",
                            fontSize: AppSize.size.width * 0.05,
                            color: AppColors.instance.black06,
                            fontWeight: FontWeight.w600,
                          ),
                          Gap(height: AppSize.size.height * 0.01),
                          AppText(
                            text: "72/90 Zen Garden Street, Tokyo, Japan",
                            fontSize: AppSize.size.width * 0.035,
                            color: AppColors.instance.black06,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CustomDecoratedBox(
                child: Padding(
                  padding: EdgeInsets.all(AppSize.size.width * 0.03),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AppImage(path: AppAssertsImagePath.instance.creditCard, height: AppSize.size.height * 0.09, fit: BoxFit.cover),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: "Payment Method",
                            fontSize: AppSize.size.width * 0.05,
                            color: AppColors.instance.black06,
                            fontWeight: FontWeight.w600,
                          ),
                          Gap(height: AppSize.size.height * 0.012),
                          AppText(
                            text: "Visa/Mastercard ending in **** **** 1234",
                            fontSize: AppSize.size.width * 0.035,
                            color: AppColors.instance.black06,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CustomDecoratedBox(
                child: Padding(
                  padding: EdgeInsets.all(AppSize.size.width * 0.035),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Product details",
                        fontSize: AppSize.size.width * 0.05,
                        color: AppColors.instance.black06,
                        fontWeight: FontWeight.w600,
                      ),
                      Gap(height: AppSize.size.height * 0.009),
                      WidgetRow(name: "Color", value: "Marron"),
                      WidgetRow(name: "Size", value: "M"),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CustomDecoratedBox(
                child: Padding(
                  padding: EdgeInsets.all(AppSize.size.width * 0.045),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      AppText(
                        text: "Order summary",
                        fontSize: AppSize.size.width * 0.05,
                        color: AppColors.instance.black06,
                        fontWeight: FontWeight.w600,
                      ),
                      Gap(height: AppSize.size.height * 0.009),
                      WidgetRow(name: "Quantity", value: "1x"),
                      WidgetRow(name: "Subtotal", value: "¥377.99"),
                      WidgetRow(name: "Shipping", value: "Free"),
                      WidgetRow(name: "Service charge", value: "37.799(10%)"),
                      WidgetRow(name: "Tax(5%)", value: "18.8995"),
                      Divider(),
                      WidgetRow(name: "Total", value: "18.8995"),
                      AppButton(
                        onTap: () {},
                        borderColor: AppColors.instance.green,
                        height: AppSize.size.height * 0.058,
                        backgroundColor: AppColors.instance.green,
                        title: "Proceed to Checkout",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: Gap(height: AppSize.size.height * 0.06)),
          ],
        ),
      ),
    );
  }
}
