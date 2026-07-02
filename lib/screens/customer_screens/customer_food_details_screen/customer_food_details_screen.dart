import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_asserts_icons_path.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/screens/customer_screens/customer_cart_screen/provider/cart_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_food_details_screen/provider/add_to_cart_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_food_details_screen/provider/page_index_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_food_details_screen/provider/review_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_food_details_screen/widgets/view_shop_widget.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/app_snack_bar.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/buttons/custom_decorated_box.dart';
import 'package:nexprime/widgets/buttons/icon_button_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../services/storage/storage_services.dart';
import '../../../widgets/buttons/app_button.dart';
import '../../../widgets/dialogs/login_popup.dart';
import '../../../widgets/texts/app_text.dart';
import 'package:nexprime/models/product_model.dart';

class CustomerFoodDetailsScreen extends ConsumerWidget {
  final ProductModel product;
  CustomerFoodDetailsScreen({super.key, required this.product});
  final PageController _pageController = PageController();

  List<String> get imageUrls => product.images.isNotEmpty
      ? product.images
      : ["https://ui-avatars.com/api/?name=No+Image&background=random"];

  void _nextPage(int currentPage) {
    if (currentPage < imageUrls.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage(int currentPage) {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  StorageServices storageServices = StorageServices.instance;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(pageIndexProvider);
    final cartState=ref.watch(addToCartProvider);
    final reviewDetails=ref.watch(reviewProvider(product.id));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: AppSize.size.height * 0.4,
              flexibleSpace: Stack(
                children: [
                  PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _pageController,
                    onPageChanged: (index) {
                      ref.read(pageIndexProvider.notifier).state = index;
                    },
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return AppImage(url: imageUrls[index], fit: BoxFit.cover);
                    },
                  ),
                  Positioned(
                    top: 30,
                    left: 16,
                    child: IconButtonWidget(
                      onTap: () {
                        AppRoutes.instance.pop();
                      },
                      icon: Icons.arrow_back,
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: AppSize.size.height * 0.2,
                    child: IconButtonWidget(
                      onTap: () => previousPage(currentPage),
                      icon: Icons.chevron_left,
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: AppSize.size.height * 0.2,
                    child: IconButtonWidget(
                      onTap: () => _nextPage(currentPage),
                      icon: Icons.chevron_right,
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(imageUrls.length, (index) {
                        bool isActive = currentPage == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 12 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive
                                ? AppColors.instance.green
                                : Colors.white.withAlpha(200),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(20),
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.instance.white50,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: DecoratedBox(
                decoration: BoxDecoration(color: AppColors.instance.white50),
                child: SizedBox(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.size.width * 0.04,
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: product.categories.isNotEmpty
                                  ? product.categories.first.name
                                  : "Category",
                              fontSize: 18,
                              color: Colors.grey.shade600,
                            ),
                            CustomDecoratedBox(
                              height: AppSize.size.height * 0.04,
                              width: AppSize.size.width * 0.25,
                              color: AppColors.instance.green,
                              child: Center(
                                child: AppText(
                                  text:
                                      '\$${product.salePrice.toStringAsFixed(2)}',
                                  color: AppColors.instance.white50,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(height: AppSize.size.width * 0.012),
                        AppText(
                          text: product.name.isNotEmpty ? product.name : "N/A",
                          fontSize: AppSize.size.width * 0.07,
                          fontWeight: FontWeight.bold,
                        ),
                        Gap(height: AppSize.size.width * 0.012),
                        Row(
                          children: [
                            reviewDetails.when(data: (reviews){
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
                                  size: AppSize.size.width * 0.055,
                                ),
                                Gap(width: AppSize.size.width * 0.012),
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
                                      extra: product.id,
                                    );
                                  },
                                  child: AppText(
                                    text: "($totalReviews reviews)",
                                    color: Colors.grey.shade600,
                                    fontSize: AppSize.size.width * 0.04,
                                  ),
                                ),
                              ],);
                            }, error: (e,_){
                              return Text(e.toString());
                            }, loading:() => SizedBox(
                              height: 10,
                                width: 10,
                                child: Center(child: CircularProgressIndicator(),)) ),

                            Spacer(),
                            Icon(
                              Icons.circle,
                              color: Colors.green,
                              size: AppSize.size.width * 0.03,
                            ),
                            Gap(width: AppSize.size.width * 0.02),
                            AppText(
                              text: "${product.stockUnits} in stock",
                              color: Colors.grey.shade600,
                              fontSize: AppSize.size.width * 0.04,
                            ),

                            Spacer(),
                            AppText(
                              text: "Copy link",
                              color: Colors.grey.shade600,
                              fontSize: AppSize.size.width * 0.04,
                            ),
                            Gap(width: AppSize.size.width * 0.01),
                            Icon(
                              Icons.copy,
                              color: Colors.grey.shade600,
                              size: AppSize.size.width * 0.045,
                            ),
                          ],
                        ),
                        Gap(height: AppSize.size.width * 0.02),
                        Divider(color: Colors.grey.shade200),
                        Gap(height: AppSize.size.width * 0.02),
                        AppText(
                          text: "Description",
                          fontSize: AppSize.size.width * 0.048,
                          fontWeight: FontWeight.bold,
                        ),
                        Gap(height: AppSize.size.width * 0.012),
                        AppText(
                          text: product.description.isNotEmpty
                              ? product.description
                              : "No description available.",
                          fontSize: AppSize.size.width * 0.037,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                        Gap(height: AppSize.size.height * 0.03),

                           AppButton(
                             title: cartState.isLoading ? "Adding..." : "Add To Cart",
                             onTap: cartState.isLoading
                                 ? null
                                 : () async {
                               try {
                                 var role = await storageServices.getAppRoll();
                                 if (role.toLowerCase() == "GUEST".toLowerCase()){
                                   callLoginDialog();
                                   return;
                                 }
                                 await ref.read(addToCartProvider.notifier).addCartData(
                                   productId: product.id,
                                   quantity: 1,
                                 );

                                 if (context.mounted) {
                                   AppSnackBar.instance.success(
                                     "Data successfully added to cart",
                                   );
                                 }
                                 await ref.read(cartProvider.notifier).getCartData();
                               } catch (e) {
                                 if (context.mounted) {
                                   AppSnackBar.instance.error(
                                     "Data add failed: $e",
                                   );
                                 }
                               }
                             },
                            backgroundColor: AppColors.instance.green,
                            borderColor: AppColors.instance.green,
                            borderRadius: BorderRadius.circular(8),
                            width: AppSize.size.width,
                            height: AppSize.size.height * 0.053,
                          ),

                        Gap(height: AppSize.size.height * 0.03),

                        ViewShopWidget(
                          onTap: () {
                            AppRoutes.instance.pushNamed(
                              AppRoutesKey.instance.customerShopScreen,
                              extra: product.storeId.toString(),
                            );
                          },
                          title: product.store.name.isNotEmpty
                              ? product.store.name
                              : 'Store',
                          image: product.store.photo.isNotEmpty
                              ? product.store.photo
                              : AppAssertsIconsPath.instance.shopIcon,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: Gap(height: AppSize.size.height * 0.02)),
          ],
        ),
      ),
    );
  }
}
