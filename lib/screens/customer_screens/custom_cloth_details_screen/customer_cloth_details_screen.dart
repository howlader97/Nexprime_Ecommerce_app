import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_asserts_icons_path.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/screens/customer_screens/custom_cloth_details_screen/provider/cloth_details_provider.dart';
import 'package:nexprime/screens/customer_screens/custom_cloth_details_screen/provider/page_provider.dart';
import 'package:nexprime/screens/customer_screens/custom_cloth_details_screen/widgets/custom_color_panel.dart';
import 'package:nexprime/screens/customer_screens/custom_cloth_details_screen/widgets/custom_size_panel.dart';
import 'package:nexprime/screens/customer_screens/custom_cloth_details_screen/widgets/product_image_slider.dart';
import 'package:nexprime/screens/customer_screens/custom_cloth_details_screen/widgets/product_title_price_widget.dart';
import 'package:nexprime/screens/customer_screens/customer_food_details_screen/widgets/view_shop_widget.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../../constant/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_size.dart';
import '../../../utils/gap.dart';
import 'package:nexprime/models/product_model.dart';
import 'package:nexprime/screens/customer_screens/customer_food_details_screen/provider/add_to_cart_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_cart_screen/provider/cart_provider.dart';
import 'package:nexprime/utils/app_snack_bar.dart';

import '../customer_food_details_screen/provider/review_provider.dart';

class CustomerClothDetailsScreen extends ConsumerStatefulWidget {
  final ProductModel product;

  const CustomerClothDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<CustomerClothDetailsScreen> createState() =>
      _CustomerClothDetailsScreenState();
}

class _CustomerClothDetailsScreenState
    extends ConsumerState<CustomerClothDetailsScreen> {
  late PageController _pageController;

  List<String> get sizes => widget.product.size.isNotEmpty
      ? widget.product.size
      : ["S", "M", "L", "XL", "XXL/2XL"];

  List<String> get imageUrls => widget.product.images.isNotEmpty
      ? widget.product.images
      : ["https://ui-avatars.com/api/?name=No+Image&background=random"];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeIndex = ref.watch(sizeProvider);
    final colorIndex = ref.watch(colorProvider);
    final currentPage = ref.watch(pageProvider);
    final cartState = ref.watch(addToCartProvider);
    final colors = ref.watch(parsedColorsProvider(widget.product.colors));
    final reviewDetails = ref.watch(reviewProvider(widget.product.id));

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            ProductImageSlider(
              pageController: _pageController,
              ref: ref,
              imageUrls: imageUrls,
              currentPage: currentPage,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.044,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductTitlePriceWidget(
                      productName: widget.product.name.isNotEmpty
                          ? widget.product.name
                          : 'N/A',
                      price: "¥${widget.product.salePrice.toStringAsFixed(2)}",
                    ),
                    Row(
                      children: [
                        AppText(
                          text:
                              "Shipping: ${widget.product.shippingResponsibility}",
                          fontSize: 16,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Gap(width: 20),
                        // if(widget.product.shippingResponsibility != "VENDOR")
                        AppText(
                          text: "Charge: ${widget.product.shippingCharge}",
                          fontSize: 16,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                    Gap(height: 5),
                    Row(
                      children: [
                        reviewDetails.when(
                          data: (reviews) {
                            double avgRating = 0;
                            int totalReviews = reviews.length;

                            if (reviews.isNotEmpty) {
                              int totalScore = 0;

                              for (var item in reviews) {
                                totalScore += item.score;
                              }

                              avgRating = totalScore / totalReviews;
                            }
                            return Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: AppSize.size.width * 0.054,
                                ),
                                Gap(width: AppSize.size.width * 0.01),
                                AppText(
                                  text: avgRating.toStringAsFixed(1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppSize.size.width * 0.046,
                                ),
                                Gap(width: AppSize.size.width * 0.012),
                                GestureDetector(
                                  onTap: () {
                                    AppRoutes.instance.pushNamed(
                                      AppRoutesKey
                                          .instance
                                          .customerReviewListScreen,
                                      extra: widget.product.id,
                                    );
                                  },
                                  child: AppText(
                                    text: "($totalReviews reviews)",
                                    color: Colors.grey.shade600,
                                    fontSize: AppSize.size.width * 0.04,
                                  ),
                                ),
                              ],
                            );
                          },
                          error: (e, _) {
                            return Text(e.toString());
                          },
                          loading: () =>
                              Center(child: CircularProgressIndicator()),
                        ),

                        Spacer(),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.instance.green,
                          ),
                          child: SizedBox(width: 8, height: 8),
                        ),
                        Gap(width: AppSize.size.width * 0.012),
                        AppText(
                          text: "${widget.product.stockUnits} in stock",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.instance.gray400,
                          ),
                        ),
                        const Spacer(),
                        AppText(text: "Tax:${widget.product.taxFee}%"),
                      ],
                    ),
                    Gap(height: AppSize.size.width * 0.03),
                    if (colors.isNotEmpty) ...[
                      CustomColorPanel(
                        colors: colors,
                        colorIndex: colorIndex,
                        ref: ref,
                      ),
                      Gap(height: AppSize.size.width * 0.03),
                    ],
                    if (sizes.isNotEmpty) ...[
                      CustomSizedPanel(
                        sizes: sizes,
                        sizeIndex: sizeIndex,
                        ref: ref,
                      ),
                      Gap(height: AppSize.size.width * 0.03),
                    ],

                    /*  Row(
                      children: [
                        AppText(
                          text: "Quantity",
                          fontSize: AppSize.size.width * 0.042,
                          fontWeight: FontWeight.bold,
                        ),
                        Gap(width: AppSize.size.width * 0.08),
                        CountButton(
                          onTap: () {
                            controller.decrement();
                          },
                          icon: Icons.remove,
                        ),
                        Gap(width: AppSize.size.height * 0.006),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(220),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSize.size.width * 0.04,
                              vertical: AppSize.size.width * 0.002,
                            ),
                            child: AppText(
                              text: product.quantity.toString(),

                              fontSize: AppSize.size.width * 0.048,
                              color: AppColors.instance.black06,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Gap(width: AppSize.size.height * 0.006),
                        CountButton(
                          onTap: () {
                            controller.increment();
                          },
                          icon: Icons.add,
                        ),
                      ],
                    ),
                    Gap(height: AppSize.size.width * 0.03),*/
                    AppText(
                      text: "Description",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    Gap(width: AppSize.size.width * 0.03),
                    AppText(
                      text: widget.product.description.isNotEmpty
                          ? widget.product.description
                          : "No description available.",
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    Gap(height: AppSize.size.width * 0.045),
                    AppButton(
                      height: AppSize.size.height * 0.05,
                      title: cartState.isLoading ? "Adding..." : "Add to Cart",
                      onTap: cartState.isLoading
                          ? null
                          : () async {
                              try {
                                final selectedSize =
                                    sizes.isNotEmpty &&
                                        sizeIndex >= 0 &&
                                        sizeIndex < sizes.length
                                    ? sizes[sizeIndex]
                                    : null;
                                final selectedColor =
                                    widget.product.colors.isNotEmpty &&
                                        colorIndex >= 0 &&
                                        colorIndex <
                                            widget.product.colors.length
                                    ? widget.product.colors[colorIndex]
                                    : null;

                                await ref
                                    .read(addToCartProvider.notifier)
                                    .addCartData(
                                      productId: widget.product.id,
                                      quantity: 1, // Add quantity if required
                                      size: selectedSize,
                                      color: selectedColor,
                                    );

                                if (context.mounted) {
                                  AppSnackBar.instance.success(
                                    "Successfully added to cart",
                                  );
                                }
                                await ref
                                    .read(cartProvider.notifier)
                                    .getCartData();
                              } catch (e) {
                                if (context.mounted) {
                                  AppSnackBar.instance.error(
                                    "Add to cart failed: $e",
                                  );
                                }
                              }
                            },
                      backgroundColor: AppColors.instance.green,
                      borderColor: AppColors.instance.green,
                    ),
                    Gap(height: AppSize.size.width * 0.03),
                    ViewShopWidget(
                      onTap: () {
                        AppRoutes.instance.pushNamed(
                          AppRoutesKey.instance.customerShopScreen,
                          extra: widget.product.storeId.toString(),
                        );
                      },
                      title: widget.product.store.name.isNotEmpty
                          ? widget.product.store.name
                          : "Store",
                      image: widget.product.store.photo.isNotEmpty
                          ? widget.product.store.photo
                          : AppAssertsIconsPath.instance.shopIcon,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
