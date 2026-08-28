import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_locations.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/screens/customer_screens/customer_groceries_home_categories/widgets/customer_groceries_home_categories_widgets.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/provider/groceries_country_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_new_product_list/provider/marketplace_location_provider.dart';
import 'package:nexprime/widgets/buttons/custom_app_bar.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/texts/app_text.dart';
import '../customer_my_product_screens/widgets/my_product_card.dart';
import '../customer_new_product_list/widgets/custom_dropdown_Button.dart';
import '../customer_profile_screen/provider/customer_profile_provider.dart';
import 'provider/marketing_product_provider.dart';

class CustomerMarketplaceScreen extends ConsumerStatefulWidget {
  const CustomerMarketplaceScreen({super.key});

  @override
  ConsumerState<CustomerMarketplaceScreen> createState() =>
      _CustomerMarketplaceScreenState();
}

class _CustomerMarketplaceScreenState
    extends ConsumerState<CustomerMarketplaceScreen> {
  @override
  void initState() {
    super.initState();
    // Every time this screen mounts (first open or navigating back),
    // clear location + category filters and fetch full fresh data.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(marketPlaceLocationProvider.notifier).clear();
      ref.read(marketingProductProvider.notifier).resetAndRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(customerProfileProvider);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Clear location filter
            ref.read(marketPlaceLocationProvider.notifier).clear();
            // Reset all filters (location + category) and fetch fresh data
            await ref
                .read(marketingProductProvider.notifier)
                .resetAndRefresh();
            ref.invalidate(groceriesProvider("Marketplace Management"));
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: CustomAppBar(
                  backButton: () {
                    AppRoutes.instance.pop();
                  },
                  title: 'Marketplace',
                  buttonTitle: 'Add Product',
                  textButton: () {
                    AppRoutes.instance.pushNamed(
                      AppRoutesKey.instance.customerNewProductList,
                    );
                  },
                ),
              ),

              SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, ref, child) {
                    final location = ref.watch(marketPlaceLocationProvider);
                    return CustomDropDownButton(
                      header: 'Location',
                      hintText: (profile.value?.location?.trim().isNotEmpty ?? false) ? (profile.value?.location ?? 'Enter location') : 'enter location',
                      value: location.isNotEmpty ? location : null,
                      items: appLocations,
                      onChanged: (v) {
                        // Update the location state provider
                        ref
                            .read(marketPlaceLocationProvider.notifier)
                            .update(v);
                        // Apply location filter (empty string → clear filter)
                        ref
                            .read(marketingProductProvider.notifier)
                            .filter(
                              location: (v != null && v.isNotEmpty) ? v : null,
                            );
                      },
                    );
                  },
                ),
              ),

              // ── Category filter ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, ref, child) {
                    final subcategories = ref.watch(
                      groceriesProvider("Marketplace Management"),
                    );
                    return subcategories != null && subcategories.isNotEmpty
                        ? CustomerGroceriesHomeCategoriesWidgets(
                            headerTitle: 'Categories',
                            categories: subcategories,
                            // Use name-based callback for marketplace filtering
                            onTapCategoryName: (name) {
                              ref
                                  .read(marketingProductProvider.notifier)
                                  .filter(
                                    goodsType:
                                        name, // null = toggle off → clear
                                  );
                            },
                          )
                        : Center(
                            child: AppText(
                              text: "No category",
                              color: Colors.black,
                            ),
                          );
                  },
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.size.width * 0.04,
                    vertical: AppSize.size.width * 0.02,
                  ),
                  child: AppText(
                    text: "Today's pics",
                    fontSize: AppSize.size.width * 0.06,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // ── Product grid ───────────────────────────────────────────────
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.042,
                ),
                sliver: Consumer(
                  builder: (context, ref, child) {
                    final marketingProducts = ref.watch(
                      marketingProductProvider,
                    );
                    return marketingProducts.when(
                      data: (products) {
                        if (products.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 40,
                                ),
                                child: AppText(
                                  text: "No products available",
                                  fontSize: AppSize.size.width * 0.04,
                                ),
                              ),
                            ),
                          );
                        }
                        return SliverGrid.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.75,
                              ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            final imageUrl =
                                (product.images != null &&
                                    product.images!.isNotEmpty)
                                ? product.images!.first
                                : 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=1026&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

                            return MyProductCard(
                              marketplace: true,
                              imageUrl: imageUrl,
                              title: product.name ?? 'Unknown',
                              price: '¥${product.price ?? 0}',
                              onTap: () {
                                AppRoutes.instance.pushNamed(
                                  AppRoutesKey
                                      .instance
                                      .customerMarketplaceProductDetails,
                                  extra: product.id,
                                );
                              },
                              onEdit: () {},
                              onDelete: () {},
                            );
                          },
                        );
                      },
                      error: (error, stack) => SliverToBoxAdapter(
                        child: Center(
                          child: AppText(
                            text: "Error loading products",
                            fontSize: AppSize.size.width * 0.04,
                          ),
                        ),
                      ),
                      loading: () => const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
