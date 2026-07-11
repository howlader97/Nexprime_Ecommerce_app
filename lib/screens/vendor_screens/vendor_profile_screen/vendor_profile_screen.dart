import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/screens/vendor_screens/vendor_profile_screen/provider/vendor_profile_provider.dart';
import 'package:nexprime/screens/vendor_screens/vendor_profile_screen/widget/vendor_profile_custom_body.dart';
import 'package:nexprime/screens/vendor_screens/vendor_profile_screen/widget/vendor_profile_edit_body.dart';
import 'package:nexprime/screens/vendor_screens/vendor_review_screen/vendor_review_screen.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/app_image/app_image_circular.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../../constant/app_asserts_icons_path.dart';
import '../../../constant/app_asserts_image_path.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/app_routes_key.dart';
import '../../../services/storage/storage_services.dart';
import '../../../utils/app_snack_bar.dart';
import '../../../utils/gap.dart';
import '../../../widgets/buttons/app_button.dart';
import '../vendor_edit_product_screen/vendor_edit_product_screen.dart';
import '../vendor_product_screen/widgets/vendor_product_product_card.dart';

class VendorProfileScreen extends ConsumerStatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  ConsumerState<VendorProfileScreen> createState() =>
      _VendorProfileScreenState();
}

class _VendorProfileScreenState extends ConsumerState<VendorProfileScreen> {
  bool isClicked = true;

  @override
  Widget build(BuildContext context) {
    final vendorStoreAsync = ref.watch(vendorStoreProvider);
    final products = vendorStoreAsync.value?.products ?? [];

    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.instance.white400,
              automaticallyImplyLeading: false,
              // expandedHeight: AppSize.size.height * 0.28,
              expandedHeight: AppSize.size.height * 0.22,
              leadingWidth: 0,
              flexibleSpace: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSize.size.width * 0.30),
                    child: Align(
                      child: AppImage(
                        width: AppSize.size.width * 0.7,
                        height: AppSize.size.height * 0.328,
                        isZomBle: true,
                        path: AppAssertsImagePath.instance.appLogo,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),

                  Positioned(
                    // top: AppSize.size.height * 0.05,
                    top: 70,
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        AppRoutes.instance.pushNamed(
                          AppRoutesKey.instance.vendorEditProfileScreen,
                        );
                      },
                      child: AppButton(
                        backgroundColor: AppColors.instance.green,
                        borderColor: AppColors.instance.green,
                        child: Row(
                          children: [
                            Image.asset(AppAssertsIconsPath.instance.editIcon, scale: 5),
                            Gap(width: AppSize.size.width * 0.02),
                            AppText(text: "Edit Profile", color: AppColors.instance.white50),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              bottom: PreferredSize(

                preferredSize: Size.fromHeight(AppSize.size.width * 0.28),
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
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        ),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.instance.error, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: vendorStoreAsync.when(
                        data: (vendorStore) => AppImageCircular(
                          width: AppSize.size.width * 0.25,
                          height: AppSize.size.width * 0.25,
                          url:
                          vendorStore?.photo ??
                              "assets/dev_image/vendor_profile_image.png",
                        ),
                        loading: () => AppImageCircular(
                          width: AppSize.size.width * 0.25,
                          height: AppSize.size.width * 0.25,
                          path:
                          "assets/dev_image/vendor_profile_image.png",
                        ),
                        error: (e, st) => AppImageCircular(
                          width: AppSize.size.width * 0.25,
                          height: AppSize.size.width * 0.25,
                          path:
                          "assets/dev_image/vendor_profile_image.png",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 120,vertical: 14),
                child: OutlinedButton(
                  onPressed: () async {
                    await StorageServices.instance.logout();
                    AppRoutes.instance.pushReplacementNamed(
                      AppRoutesKey.instance.signInScreen,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.green),
                  ),
                  child: AppText( text: "Logout", style: TextStyle(color: Colors.green)),
                ),
              ),
            ),

            /// PROFILE BODY
            if (isClicked)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.size.height * 0.015,
                  ),
                  child: vendorStoreAsync.when(
                    data: (vendorStore) {
                      final likesValue = vendorStore != null
                          ? ref.watch(vendorLikesProvider(vendorStore.id)).value
                          : 0;
                      return VendorProfileCustomBody(
                        vendorStore: vendorStore,
                        likes: likesValue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VendorReviewScreen(),
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                    const Center(child: CircularProgressIndicator()),
                    error: (e, st) => Center(child: Text(e.toString())),
                  ),
                ),
              )
            else
              SliverToBoxAdapter(
                child: VendorProfileEditBody(
                  vendorStore: vendorStoreAsync.value,
                  onSave: () {
                    setState(() {
                      isClicked = true;
                    });
                  },
                ),
              ),

            /// PRODUCTS
            if (isClicked)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.size.width * 0.04,
                    vertical: AppSize.size.height * 0.004,
                  ),
                  child: const AppText(
                    text: "Popular Product",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            if (isClicked)
              products.isEmpty
                  ? SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: AppText( text:
                    "No products found",
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.instance.black06,
                      ),
                    ),
                  ),
                ),
              )
                  : SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.04,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = products[index];
                    return VendorProductProductCard(
                      title: product.name,
                      description: product.description,
                      price:
                      "\$${product.isDiscountSale ? product.salePrice : product.basePrice}",
                      oldPrice: product.isDiscountSale
                          ? "\$${product.basePrice}"
                          : "",
                      stock: "Stock:${product.stockUnits}",
                      image: product.images.isNotEmpty
                          ? product.images.first
                          : "assets/dev_image/product_pizza.png",
                      delete: () => _onDeleteProduct(product.id),
                      edit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VendorEditProductScreen(product: product),
                          ),
                        );
                      },
                    );
                  }, childCount: products.length),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onDeleteProduct(int? productId) async {
    if (productId == null) return;

    final confirm = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText( text:
        "Delete Product",
          style: TextStyle(color: Colors.black),
        ),
        content: const AppText( text:
        "Are you sure you want to delete this product?",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const AppText( text: "Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const AppText( text: "Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref
          .read(vendorStoreProvider.notifier)
          .deleteProduct(productId);
      if (success) {
        AppSnackBar.instance.success("Product deleted successfully");
      } else {
        AppSnackBar.instance.error("Failed to delete product");
      }
    }
  }
}
