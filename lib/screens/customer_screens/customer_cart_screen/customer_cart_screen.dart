import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/screens/customer_screens/customer_cart_screen/provider/cart_provider.dart';
import 'package:nexprime/utils/app_snack_bar.dart';
import 'package:nexprime/utils/gap.dart';
import '../../../constant/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/app_routes_key.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/buttons/app_button.dart';
import '../../../widgets/buttons/custom_decorated_box.dart';
import '../../../widgets/buttons/icon_button_widget.dart';
import '../../../widgets/texts/app_text.dart';
import '../customer_cloth_checkout_screen/widgets/widget_row.dart';

class CustomerCartScreen extends ConsumerWidget {
  const CustomerCartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.refresh(cartProvider.notifier).getCartData();
          },
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    AppText(
                      text: "My Cart",
                      fontSize: AppSize.size.width * 0.055,
                      color: AppColors.instance.black06,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              ...cartAsync.when(
                data: (cart) {
                  if (cart == null || cart.items.isEmpty) {
                    return [
                      SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: AppText(
                              text: "Cart is empty",
                                  color: AppColors.instance.black06,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,),

                          ),
                        ),
                      ),
                    ];
                  }
                  final subtotal = cart.items.fold<double>(0, (sum, item) {
                    final price = item.product.salePrice > 0
                        ? item.product.salePrice
                        : item.product.basePrice;

                    return sum + (price * item.quantity);
                  });

                  final itemSlivers = cart.items.map((cartItem) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: AppSize.size.height * 0.02,
                        ),
                        child: CustomDecoratedBox(
                          height: AppSize.size.height * 0.18,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: AppImage(
                                    width: AppSize.size.width * 0.4,
                                    url: cartItem.product.images.isNotEmpty
                                        ? cartItem.product.images.first
                                        : "https://www.yellowclothing.net/cdn/shop/files/DSC0004288_16.jpg?v=1771044529",
                                  ),
                                ),
                                Gap(width: AppSize.size.width * 0.028),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        text: cartItem.product.name.isNotEmpty
                                            ? cartItem.product.name
                                            : "",
                                        fontSize: AppSize.size.width * 0.047,
                                        color: AppColors.instance.black06,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      Gap(height: AppSize.size.height * 0.007),
                                      AppText(
                                        text:
                                            cartItem
                                                .product
                                                .description
                                                .isNotEmpty
                                            ? cartItem.product.description
                                            : "",
                                        maxLines: 3,
                                        fontSize: AppSize.size.width * 0.04,
                                        overflow: TextOverflow.ellipsis,
                                        color: AppColors.instance.black06,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          AppText(
                                            text:
                                                "\$${(cartItem.product.salePrice > 0 ? cartItem.product.salePrice : cartItem.product.basePrice).toStringAsFixed(2)}",
                                            fontSize:
                                                AppSize.size.width * 0.047,
                                            color: AppColors.instance.black06,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          Gap(
                                            width: AppSize.size.height * 0.015,
                                          ),
                                          IconButtonWidget(
                                            padding: AppSize.size.width * 0.008,
                                            icon: Icons.remove,
                                            onTap: () {
                                              if (cartItem.quantity > 1) {
                                                ref
                                                    .read(cartProvider.notifier)
                                                    .updateQuantity(
                                                      cartItem.id,
                                                      "decrease",
                                                    );
                                              } else {
                                                AppSnackBar.instance.error(
                                                  "minimum quantity",
                                                );
                                              }
                                            },
                                          ),
                                          Gap(
                                            width: AppSize.size.height * 0.006,
                                          ),
                                          AppText(
                                            fontSize: AppSize.size.width * 0.05,
                                            text: cartItem.quantity.toString(),
                                          ),
                                          Gap(
                                            width: AppSize.size.height * 0.006,
                                          ),
                                          IconButtonWidget(
                                            padding: AppSize.size.width * 0.008,
                                            icon: Icons.add,
                                            onTap: () {
                                              if (cartItem.quantity <
                                                  cartItem.product.stockUnits) {
                                                ref
                                                    .read(cartProvider.notifier)
                                                    .updateQuantity(
                                                      cartItem.id,
                                                      "increase",
                                                    );
                                              } else {
                                                AppSnackBar.instance.error(
                                                  "Insufficient stock quantity",
                                                );
                                              }
                                            },
                                          ),
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
                    );
                  }).toList();

                  final bottomSliver = SliverToBoxAdapter(
                    child: CustomDecoratedBox(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.size.width * 0.04,
                          vertical: AppSize.size.height * 0.03,
                        ),
                        child: Column(
                          spacing: 10,
                          children: [
                            WidgetRow(
                              name: "Subtotal",
                              value: "\$${subtotal.toStringAsFixed(2)}",
                            ),
                            WidgetRow(
                              name: "Shipping",
                              value:
                                  "\$${cart.items.fold(0.0, (sum, item) => sum + item.product.shippingCharge).toStringAsFixed(2)}",
                            ),
                            const Divider(),
                            WidgetRow(
                              name: "Total",
                              value: "\$${cart.totalAmount.toStringAsFixed(2)}",
                            ),
                            Gap(height: AppSize.size.height * 0.016),
                            AppButton(
                              onTap: () {
                                AppRoutes.instance.pushNamed(
                                  AppRoutesKey.instance.customerDeliveryInfo,
                                );
                              },
                              height: AppSize.size.height * 0.053,
                              backgroundColor: AppColors.instance.green,
                              borderColor: AppColors.instance.green,
                              title: "Proceed to Checkout",
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                  return [...itemSlivers, bottomSliver];
                },
                loading: () => [
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ],
                error: (error, stack) => [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Center(child: Text("Error: ${error.toString()}")),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
