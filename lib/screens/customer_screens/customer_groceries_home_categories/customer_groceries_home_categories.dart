import 'package:flutter/material.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/screens/customer_screens/customer_groceries_home_categories/provider/product_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_groceries_home_categories/widgets/customer_groceries_home_categories_widgets.dart';
import 'package:nexprime/screens/customer_screens/customer_groceries_home_categories/widgets/product_cart_widgets.dart';
import 'package:nexprime/screens/customer_screens/customer_groceries_home_categories/widgets/shop_section_widget.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/app_snack_bar.dart';
import 'package:nexprime/widgets/buttons/custom_app_bar.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import '../../../constant/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/provider/groceries_country_provider.dart';
import '../customer_cart_screen/provider/cart_provider.dart';
import '../customer_food_details_screen/provider/add_to_cart_provider.dart';

class CustomerGroceriesHomeCategories extends ConsumerWidget {
  final int countryId;
  final String countryName;

  const CustomerGroceriesHomeCategories({super.key, required this.countryId, required this.countryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subcategories = ref.watch(groceriesProvider("Grocery"));
    final productState = ref.watch(productProvider(countryId));
    final cart = ref.watch(addToCartProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: CustomAppBar(
                backButton: () {
                  AppRoutes.instance.pop();
                },
                title: countryName,
              ),
            ),
            SliverToBoxAdapter(child: ShopsSectionWidget(countryId: countryId)),

            SliverToBoxAdapter(
              child: CustomerGroceriesHomeCategoriesWidgets(headerTitle: "Categories", categories: subcategories, countryId: countryId),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: AppText(
                  text: "Best Offer",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.instance.black06),
                ),
              ),
            ),
            productState.when(
              data: (products) {
                final bestOfferProducts = products.where((product) => product.isDiscountSale == true).toList();

                if (bestOfferProducts.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 50),
                        child: AppText(
                          text: "No products available",
                          style: TextStyle(color: AppColors.instance.black06, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                }
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: SizedBox(
                      height: AppSize.size.height * 0.21,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: bestOfferProducts.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final product = bestOfferProducts[index];
                          return GestureDetector(
                            onTap: () {
                              AppRoutes.instance.pushNamed(AppRoutesKey.instance.customerFoodDetailsScreen, extra: product);
                            },
                            child: ProductCartWidget(
                              image: product.images.isNotEmpty ? product.images.first : "no image",
                              itemTitle: product.name,
                              price: "${product.salePrice}",
                              discountPrice: product.isDiscountSale ? "${product.discountPercentage}% OFF" : "",
                              onTap: cart.isLoading
                                  ? null
                                  : () async {
                                      try {
                                        await ref.read(addToCartProvider.notifier).addCartData(productId: product.id, quantity: 1);

                                        if (context.mounted) {
                                          AppSnackBar.instance.success("successfully added to cart");
                                        }
                                        await ref.read(cartProvider.notifier).getCartData();
                                      } catch (e) {
                                        if (context.mounted) {
                                          AppSnackBar.instance.error("Data add failed: $e");
                                        }
                                      }
                                    },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),

              error: (e, _) => SliverToBoxAdapter(child: Center(child: Text(e.toString()))),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: AppText(text: "Featured Food", fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.instance.black06),
              ),
            ),
            productState.when(
              data: (products) {
                final featuresProducts = products.where((product) => product.isDiscountSale == false).toList();
                if (featuresProducts.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 50),
                        child: AppText(
                          text: "No products available",
                          style: TextStyle(fontSize: 18, color: AppColors.instance.black06, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                }
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: SizedBox(
                      height: AppSize.size.height * 0.188,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: featuresProducts.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final product = featuresProducts[index];
                          return GestureDetector(
                            onTap: () {
                              AppRoutes.instance.pushNamed(AppRoutesKey.instance.customerFoodDetailsScreen, extra: product);
                            },
                            child: ProductCartWidget(
                              isFeatures: true,
                              image: product.images.isNotEmpty ? product.images.first : "",
                              itemTitle: product.name,
                              price: "${product.salePrice}",
                              onPressed: cart.isLoading
                                  ? null
                                  : () async {
                                      try {
                                        await ref.read(addToCartProvider.notifier).addCartData(productId: product.id, quantity: 1);

                                        if (context.mounted) {
                                          AppSnackBar.instance.success("successfully added to cart");
                                        }
                                        await ref.read(cartProvider.notifier).getCartData();
                                      } catch (e) {
                                        if (context.mounted) {
                                          AppSnackBar.instance.error("Data add failed: $e");
                                        }
                                      }
                                    },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),

              error: (e, _) => SliverToBoxAdapter(child: Center(child: Text(e.toString()))),
            ),
          ],
        ),
      ),
    );
  }
}
