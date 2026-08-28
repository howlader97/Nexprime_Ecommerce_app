import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/screens/customer_screens/customer_groceries_home_categories/widgets/customer_groceries_home_categories_widgets.dart';
import 'package:nexprime/screens/customer_screens/customer_profile_screen/provider/customer_profile_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_shop_screen/provider/customer_shop_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_shop_screen/provider/shop_product_filter_provider.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/buttons/icon_button_widget.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import '../../../constant/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_snack_bar.dart';
import '../../../widgets/app_image/app_image_circular.dart';
import '../customer_cart_screen/provider/cart_provider.dart';
import '../customer_food_details_screen/provider/add_to_cart_provider.dart';
import '../customer_groceries_home_categories/widgets/product_cart_widgets.dart';
import '../customer_home_screen/provider/groceries_country_provider.dart';

class CustomerShopScreen extends ConsumerWidget {
  final String storeId;

  const CustomerShopScreen({super.key, required this.storeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopData = ref.watch(customerShopProvider(int.parse(storeId)));
    final groceryCategories = ref.watch(groceriesProvider("grocery"));
    final wardrobeCategories = ref.watch(groceriesProvider("wardrobe"));
    final cart = ref.watch(addToCartProvider);
    final groceryFilterState = ref.watch(
      groceryFilterProvider(int.parse(storeId)),
    );
    final wardrobeFilterState = ref.watch(
      wardrobeFilterProvider(int.parse(storeId)),
    );

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            shopData.when(
              data: (shop) {
                return SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: AppSize.size.height * 0.27,
                  flexibleSpace: Stack(
                    children: [
                      AppImage(
                        width: AppSize.size.width,
                        isZomBle: true,
                        url: shop?.coverImgUrl ?? "",
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: IconButtonWidget(
                          onTap: () {
                            AppRoutes.instance.pop();
                          },
                          icon: Icons.arrow_back,
                        ),
                      ),
                    ],
                  ),

                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(AppSize.size.width * 0.3),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Gap(width: AppSize.size.width),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: AppSize.size.width * 0.15,
                            width: AppSize.size.width,
                            decoration: BoxDecoration(
                              color: AppColors.instance.white50,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.instance.error,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: AppImageCircular(
                            width: AppSize.size.width * 0.3,
                            height: AppSize.size.width * 0.30,
                            fit: BoxFit.cover,
                            url: shop?.photo,
                          ),
                        ),
                      ],
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
            shopData.when(
              data: (shop) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.size.width * 0.04,
                      vertical: AppSize.size.width * 0.02,
                    ),
                    child: Column(
                      spacing: 5,
                      children: [
                        AppText(
                          text: shop?.name ?? "",
                          fontWeight: FontWeight.bold,
                          fontSize: AppSize.size.width * 0.06,
                        ),
                        AppText(
                          text: shop?.bio ?? 'no bio',
                          fontSize: AppSize.size.width * 0.04,
                          color: AppColors.instance.black06,
                          fontWeight: FontWeight.w400,
                        ),
                        Divider(color: AppColors.instance.grayEE),
                        Row(
                          children: [
                            AppText(
                              text: "${shop?.followerCount} People following",
                            ),
                            const Spacer(),
                            AppText(text: "${shop?.products.length} Products"),
                            const Spacer(),
                            AppButton(
                              onTap: () {
                                ref
                                    .read(
                                      customerShopProvider(
                                        int.parse(storeId),
                                      ).notifier,
                                    )
                                    .toggleFollow();
                              },
                              padding: EdgeInsets.all(
                                AppSize.size.width * 0.016,
                              ),
                              backgroundColor: shop?.isFollowing == true
                                  ? AppColors.instance.green
                                  : AppColors.instance.green,
                              borderColor: shop?.isFollowing == true
                                  ? AppColors.instance.green
                                  : AppColors.instance.green,
                              title: shop?.isFollowing == true
                                  ? "Unfollow"
                                  : "Follow",
                            ),
                          ],
                        ),
                        Divider(color: AppColors.instance.grayEE),

                        Consumer(
                          builder: (context, ref, child) {
                            final currentUser = ref.read(
                              customerProfileProvider,
                            );
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: AppButton(
                                height: AppSize.size.height * 0.065,
                                title:
                                    shopData.value?.vendorId == currentUser.value?.id
                                    ? "Own Product"
                                    : "Message Seller",
                                onTap: () {
                                  if (shopData.value?.vendorId ==
                                      currentUser.value?.id) {
                                    return;
                                  }
                                  AppRoutes.instance.pushNamed(
                                    AppRoutesKey.instance.customerChatScreen,
                                    extra: {
                                      "userId": shopData.value?.vendor?.id,
                                      "name": shopData.value?.vendor?.fullname,
                                      "profileImageUrl": shopData.value?.photo,
                                      "showReport": false,
                                    },
                                  );
                                },

                                backgroundColor: AppColors.instance.green,
                                borderColor: AppColors.instance.green,
                              ),
                            );
                          },
                        ),
                      ],
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

            shopData.when(
              data: (shop) {
                final storeGroceryCategoryNames =
                    shop?.products
                        .where((p) => p.size.isEmpty || p.colors.isEmpty)
                        .expand((p) => p.categories)
                        .map((c) => c.name.toLowerCase().trim())
                        .toSet() ??
                    {};

                final filteredGroceryCategories =
                    groceryCategories
                        ?.where(
                          (cat) => storeGroceryCategoryNames.contains(
                            cat.name.toLowerCase().trim(),
                          ),
                        )
                        .toList() ??
                    [];

                return SliverToBoxAdapter(
                  child: CustomerGroceriesHomeCategoriesWidgets(
                    headerTitle: "Categories",
                    categories: filteredGroceryCategories,
                    onTapCategory: (categoryId) {
                      ref
                          .read(
                            groceryFilterProvider(int.parse(storeId)).notifier,
                          )
                          .filterProducts(categoryId);
                    },
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: CustomerGroceriesHomeCategoriesWidgets(
                  headerTitle: "Categories",
                  categories: null,
                ),
              ),
              error: (e, _) =>
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: AppSize.size.width * 0.04),
                child: AppText(
                  text: "Popular Food",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.instance.black06,
                ),
              ),
            ),
            groceryFilterState.when(
              data: (filteredList) {
                return shopData.when(
                  data: (shop) {
                    final productsToDisplay =
                        filteredList ??
                        shop?.products.where((product) {
                          final sizes = product.size;
                          final colors = product.colors;
                          return (sizes.isEmpty) || (colors.isEmpty);
                        }).toList();

                    if (productsToDisplay == null ||
                        productsToDisplay.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: AppText(
                              text: 'No Data Available',
                              style: TextStyle(
                                fontSize: 16,
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: SizedBox(
                          height: AppSize.size.height * 0.188,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: productsToDisplay.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final shopProduct = productsToDisplay[index];
                              return GestureDetector(
                                onTap: () {
                                  AppRoutes.instance.pushReplacement(
                                    AppRoutesKey
                                        .instance
                                        .customerFoodDetailsScreen,
                                    extra: shopProduct,
                                  );
                                },
                                child: ProductCartWidget(
                                  isFeatures: true,
                                  image: (shopProduct.images.isNotEmpty)
                                      ? shopProduct.images.first
                                      : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKlRaR5caTW_XylgFXGqmBaytwGPyWYnMFYK3Osuk4Pw&s',
                                  itemTitle: shopProduct.name,
                                  price: '¥${shopProduct.salePrice}',
                                  onPressed: cart.isLoading
                                      ? null
                                      : () async {
                                          try {
                                            await ref
                                                .read(
                                                  addToCartProvider.notifier,
                                                )
                                                .addCartData(
                                                  productId: shopProduct.id,
                                                  quantity: 1,
                                                );

                                            if (context.mounted) {
                                              AppSnackBar.instance.success(
                                                "Data successfully added to cart",
                                              );
                                            }
                                            await ref
                                                .read(cartProvider.notifier)
                                                .getCartData();
                                          } catch (e) {
                                            if (context.mounted) {
                                              AppSnackBar.instance.error(
                                                "Data add failed: $e",
                                              );
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
                  loading: () => const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => SliverToBoxAdapter(
                    child: Center(child: Text(e.toString())),
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) =>
                  SliverToBoxAdapter(child: Center(child: Text(e.toString()))),
            ),
            shopData.when(
              data: (shop) {
                final storeWardrobeCategoryNames =
                    shop?.products
                        .where((p) => p.size.isNotEmpty || p.colors.isNotEmpty)
                        .expand((p) => p.categories)
                        .map((c) => c.name.toLowerCase().trim())
                        .toSet() ??
                    {};

                final filteredWardrobeCategories =
                    wardrobeCategories
                        ?.where(
                          (cat) => storeWardrobeCategoryNames.contains(
                            cat.name.toLowerCase().trim(),
                          ),
                        )
                        .toList() ??
                    [];

                return SliverToBoxAdapter(
                  child: CustomerGroceriesHomeCategoriesWidgets(
                    headerTitle: "Categories",
                    categories: filteredWardrobeCategories,
                    onTapCategory: (categoryId) {
                      ref
                          .read(
                            wardrobeFilterProvider(int.parse(storeId)).notifier,
                          )
                          .filterProducts(categoryId);
                    },
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: CustomerGroceriesHomeCategoriesWidgets(
                  headerTitle: "Categories",
                  categories: null,
                ),
              ),
              error: (e, _) =>
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: AppSize.size.width * 0.04),
                child: AppText(
                  text: "Clothing",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.instance.black06,
                  ),
                ),
              ),
            ),
            wardrobeFilterState.when(
              data: (filteredList) {
                return shopData.when(
                  data: (shop) {
                    final productsToDisplay =
                        filteredList ??
                        shop?.products.where((product) {
                          final sizes = product.size;
                          final colors = product.colors;
                          return (sizes.isNotEmpty) || (colors.isNotEmpty);
                        }).toList();

                    if (productsToDisplay == null ||
                        productsToDisplay.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: AppText(
                              text: 'No Data Available',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: SizedBox(
                          height: AppSize.size.height * 0.188,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: productsToDisplay.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final shopProduct = productsToDisplay[index];
                              return GestureDetector(
                                onTap: () {
                                  AppRoutes.instance.pushReplacement(
                                    AppRoutesKey
                                        .instance
                                        .customerClothDetailsScreen,
                                    extra: shopProduct,
                                  );
                                },
                                child: ProductCartWidget(
                                  isFeatures: true,
                                  image: (shopProduct.images.isNotEmpty)
                                      ? shopProduct.images.first
                                      : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKlRaR5caTW_XylgFXGqmBaytwGPyWYnMFYK3Osuk4Pw&s',
                                  itemTitle: shopProduct.name,
                                  price: '¥${shopProduct.salePrice}',
                                  onPressed: (){
                                    AppRoutes.instance.pushReplacement(
                                      AppRoutesKey
                                          .instance
                                          .customerClothDetailsScreen,
                                      extra: shopProduct,
                                    );
                                  },
                                  // onPressed: cart.isLoading
                                  //     ? null
                                  //     : () async {
                                  //         try {
                                  //           await ref
                                  //               .read(
                                  //                 addToCartProvider.notifier,
                                  //               )
                                  //               .addCartData(
                                  //                 productId: shopProduct.id,
                                  //                 quantity: 1,
                                  //               );
                                  //
                                  //           if (context.mounted) {
                                  //             AppSnackBar.instance.success(
                                  //               "Data successfully added to cart",
                                  //             );
                                  //           }
                                  //           await ref
                                  //               .read(cartProvider.notifier)
                                  //               .getCartData();
                                  //         } catch (e) {
                                  //           if (context.mounted) {
                                  //             AppSnackBar.instance.error(
                                  //               "Data add failed: $e",
                                  //             );
                                  //           }
                                  //         }
                                  //       },
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
                  error: (e, _) => SliverToBoxAdapter(
                    child: Center(child: Text(e.toString())),
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
