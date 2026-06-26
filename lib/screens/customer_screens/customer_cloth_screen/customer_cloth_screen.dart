import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/screens/customer_screens/customer_cloth_screen/provider/size_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_groceries_home_categories/widgets/custom_location_widget.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/buttons/custom_app_bar.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../../constant/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_size.dart';
import '../customer_groceries_home_categories/widgets/customer_groceries_home_categories_widgets.dart';
import '../customer_groceries_home_categories/widgets/product_cart_widgets.dart';
import '../customer_groceries_home_categories/widgets/shop_section_widget.dart';

import 'package:nexprime/screens/customer_screens/customer_home_screen/provider/groceries_country_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_groceries_home_categories/provider/product_provider.dart';

import '../customer_profile_screen/provider/customer_profile_provider.dart';

class CustomerClothScreen extends ConsumerStatefulWidget {
  final int countryId;
  final String categoryName;

  const CustomerClothScreen({
    super.key,
    required this.countryId,
    required this.categoryName,
  });

  @override
  ConsumerState<CustomerClothScreen> createState() =>
      _CustomerClothScreenState();
}

class _CustomerClothScreenState extends ConsumerState<CustomerClothScreen> {
  final List<String> sizes = ["S", "M", "L", "XL", "XXL"];

  @override
  Widget build(BuildContext context) {
    final profile=ref.watch(customerProfileProvider);
    final selectedSizeIndex = ref.watch(selectedSizeProvider);
    final subcategories = ref.watch(groceriesProvider("Wardrobe"));
    final productState = ref.watch(productProvider(widget.countryId));

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: CustomAppBar(
                backButton: () {
                  AppRoutes.instance.pop();
                },
                title: widget.categoryName,
              ),
            ),
            SliverToBoxAdapter(
              child: CustomLocationWidget(location: (profile?.locaion?.trim().isNotEmpty ?? false)
                  ? profile!.locaion!
                  : 'Japan',),
            ),
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: EdgeInsets.all(AppSize.size.width * 0.04),
            //     child: CustomSearchBar(),
            //   ),
            // ),
            SliverToBoxAdapter(child: ShopsSectionWidget(countryId: widget.countryId,)),
            SliverToBoxAdapter(
              child: CustomerGroceriesHomeCategoriesWidgets(
                headerTitle: "Types of cloths",
                categories: subcategories,
                countryId: widget.countryId,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.instance.grayEE,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                    height: AppSize.size.width * 0.26,
                    child: Padding(
                      padding: EdgeInsets.all(AppSize.size.width * 0.042),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText( text:
                          "Size",
                            style: TextStyle(
                              fontSize: AppSize.size.width * 0.048,
                              fontWeight: FontWeight.w600,
                              color: AppColors.instance.black06,
                            ),
                          ),
                          Gap(height: AppSize.size.width * 0.015),
                          SizedBox(
                            height: AppSize.size.width * 0.09,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: sizes.length,
                              itemBuilder: (context, index) {
                                bool isSelected = selectedSizeIndex == index;
                                return GestureDetector(
                                  onTap: () {
                                    if (selectedSizeIndex == index) {
                                      ref
                                          .read(selectedSizeProvider.notifier)
                                          .state = -1; // Deselect
                                      ref
                                          .read(productProvider(widget.countryId)
                                          .notifier)
                                          .getProduct(clearSize: true);
                                    } else {
                                      ref
                                          .read(selectedSizeProvider.notifier)
                                          .state = index;
                                      ref
                                          .read(productProvider(widget.countryId)
                                          .notifier)
                                          .getProduct(size: sizes[index]);
                                    }
                                  },
                                  child: Container(
                                    width: AppSize.size.width * 0.18,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.black.withAlpha(50)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: AppText(
                                        text: sizes[index],
                                        fontSize: AppSize.size.width * 0.035,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: AppColors.instance.black06,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: AppText( text:
                "Clothing",
                  style: TextStyle(
                    fontSize: AppSize.size.width * 0.056,
                    fontWeight: FontWeight.bold,
                    color: AppColors.instance.black06,
                  ),
                ),
              ),
            ),
            productState.when(
              data: (products) {
                if (products.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: AppText( text:
                        "No products available",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.instance.black06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: SizedBox(
                      height: AppSize.size.height * 0.188,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: products.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return GestureDetector(
                            onTap: () {
                              AppRoutes.instance.pushNamed(
                                  AppRoutesKey.instance.customerClothDetailsScreen,extra: product
                              );
                            },
                            child: ProductCartWidget(
                              isFeatures: true,
                              image: product.images.isNotEmpty
                                  ? product.images.first
                                  : "",
                              itemTitle: product.name,
                              price: "${product.salePrice}",
                              onPressed: () {
                                AppRoutes.instance.pushNamed(
                                  AppRoutesKey.instance.customerCartScreen,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) =>
                  SliverToBoxAdapter(child: Center(child: Text(e.toString()))),
            ),
          ],
        ),
      ),
    );
  }
}
