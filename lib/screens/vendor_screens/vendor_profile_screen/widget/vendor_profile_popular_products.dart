import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/models/vendor_store_model.dart';
import 'package:nexprime/screens/vendor_screens/vendor_edit_product_screen/vendor_edit_product_screen.dart';
import 'package:nexprime/screens/vendor_screens/vendor_product_screen/widgets/vendor_product_product_card.dart';
import 'package:nexprime/screens/vendor_screens/vendor_profile_screen/provider/vendor_profile_provider.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/app_snack_bar.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VendorProfilePopularProducts extends ConsumerWidget {
  final AsyncValue<VendorStoreModel?> vendorStoreAsync;

  const VendorProfilePopularProducts({super.key, required this.vendorStoreAsync});

  void _onDeleteProduct(BuildContext context, WidgetRef ref, int? productId) async {
    if (productId == null) return;

    final confirm = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(
          text: "Delete Product",
          style: TextStyle(color: Colors.black),
        ),
        content: const AppText(
          text: "Are you sure you want to delete this product?",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const AppText(text: "Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const AppText(
              text: "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref.read(vendorStoreProvider.notifier).deleteProduct(productId);
      if (success) {
        AppSnackBar.instance.success("Product deleted successfully");
      } else {
        AppSnackBar.instance.error("Failed to delete product");
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverMainAxisGroup(
      slivers: [
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
        vendorStoreAsync.when(
          data: (vendorStore) {
            final products = vendorStore?.products ?? [];
            return products.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: AppText(
                          text: "No products found",
                          style: TextStyle(fontSize: 18, color: AppColors.instance.black06),
                        ),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.04),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = products[index];
                          return VendorProductProductCard(
                            title: product.name,
                            description: product.description,
                            price: "¥${product.isDiscountSale ? product.salePrice : product.basePrice}",
                            oldPrice: product.isDiscountSale ? "¥${product.basePrice}" : "",
                            stock: "Stock:${product.stockUnits}",
                            image: product.images.isNotEmpty ? product.images.first : "",
                            delete: () => _onDeleteProduct(context, ref, product.id),
                            edit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VendorEditProductScreen(product: product),
                                ),
                              );
                            },
                          );
                        },
                        childCount: products.length,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                    ),
                  );
          },
          loading: () => Skeletonizer.sliver(
            enabled: true,
            child: SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.04),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return VendorProductProductCard(
                      isClickable: false,
                      title: "name",
                      description: "description",
                      price: "¥10",
                      oldPrice: "",
                      stock: "Stock:",
                      image: "",
                      delete: () {},
                      edit: () {},
                    );
                  },
                  childCount: 10,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
              ),
            ),
          ),
          error: (e, st) => SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: AppText(
                  text: "No products found",
                  style: TextStyle(fontSize: 18, color: AppColors.instance.black06),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
