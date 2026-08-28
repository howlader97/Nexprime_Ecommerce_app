import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/screens/vendor_screens/vendor_product_screen/widgets/vendor_product_app_bar.dart';
import 'package:nexprime/screens/vendor_screens/vendor_product_screen/widgets/vendor_product_product_card.dart';
import 'package:nexprime/screens/vendor_screens/vendor_profile_screen/provider/vendor_profile_provider.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import '../../../utils/app_size.dart';
import '../../../utils/app_snack_bar.dart';
import '../../customer_screens/customer_home_screen/provider/groceries_country_provider.dart';
import '../vendor_add_product_screen/vendor_add_product_screen.dart';
import '../vendor_edit_product_screen/vendor_edit_product_screen.dart';
import 'provider/vendor_product_category_provider.dart';
import 'package:nexprime/models/product_model.dart';
import 'widgets/vendor_categories_widget.dart';

class VendorProductScreen extends ConsumerStatefulWidget {
  const VendorProductScreen({super.key});

  @override
  ConsumerState<VendorProductScreen> createState() => _VendorProductScreenState();
}

class _VendorProductScreenState extends ConsumerState<VendorProductScreen> {
  int selectedIndex = 0;
  late final screenWidth = MediaQuery.of(context).size.width;

  Widget _buildProductCard(ProductModel product) {
    return VendorProductProductCard(
      title: product.name,
      description: product.description,
      price: "¥${product.isDiscountSale ? product.salePrice : product.basePrice}",
      oldPrice: product.isDiscountSale ? "¥${product.basePrice}" : "",
      stock: "Stock:${product.stockUnits}",
      image: product.images.isNotEmpty ? product.images.first : "a",
      edit: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => VendorEditProductScreen(product: product)));
      },
      delete: () => _onDeleteProduct(product.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vendorProduct = ref.watch(vendorStoreProvider);
    final grocery = ref.watch(groceriesProvider("Grocery"));
    final wardrobe = ref.watch(groceriesProvider("Wardrobe"));

    final storeData = vendorProduct.value;
    final allProducts = storeData?.products ?? [];

    final selectedGroceryId = ref.watch(vendorSelectedGroceryCategoryProvider);
    final selectedWardrobeId = ref.watch(vendorSelectedWardrobeCategoryProvider);

    var genericProducts = allProducts.where((p) => p.size.isEmpty && p.colors.isEmpty).toList();
    if (selectedGroceryId != null) {
      genericProducts = genericProducts.where((p) => p.categories.any((c) => c.id == selectedGroceryId)).toList();
    }
    final firstListProducts = genericProducts;

    var clotheProducts = allProducts.where((p) => p.size.isNotEmpty || p.colors.isNotEmpty).toList();
    if (selectedWardrobeId != null) {
      clotheProducts = clotheProducts.where((p) => p.categories.any((c) => c.id == selectedWardrobeId)).toList();
    }
    final clothingProducts = clotheProducts;
    final isLoading = vendorProduct.isLoading;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSize.size.height * 0.02, horizontal: AppSize.size.width * 0.02),
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(vendorStoreProvider.notifier).fetchVendorStoreData();
            ref.read(groceriesProvider("Grocery").notifier).getCountry("Grocery");
            ref.read(groceriesProvider("Wardrobe").notifier).getCountry("Wardrobe");
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.instance.white50,

                elevation: 0,
                automaticallyImplyLeading: false,
                title: const _Header(),
              ),

              SliverToBoxAdapter(
                child: VendorCategoriesWidget(
                  headerTitle: "Categories",
                  categories: grocery,
                  selectedCategoryIdProvider: vendorSelectedGroceryCategoryProvider,
                ),
              ),

              if (isLoading)
                const SliverToBoxAdapter(
                  child: SizedBox(height: 440, child: Center(child: CircularProgressIndicator())),
                )
              else if (firstListProducts.isEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: AppText(
                        text: "No products found",
                        style: TextStyle(fontSize: 18, color: AppColors.instance.black06),
                      ),
                    ),
                  ),
                )
              else if (firstListProducts.length <= 4)
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.02),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final product = firstListProducts[index];
                      return _buildProductCard(product);
                    }, childCount: firstListProducts.length),
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 440,
                    child: GridView.builder(
                      // padding: EdgeInsets.symmetric(
                      //   horizontal: AppSize.size.width * 0.02,
                      // ),
                      scrollDirection: Axis.horizontal,
                      itemCount: firstListProducts.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 rows
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        mainAxisExtent: 180, // width of each item
                      ),
                      itemBuilder: (context, index) {
                        final product = firstListProducts[index];
                        return _buildProductCard(product);
                      },
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(height: 20),
                    AppText(text: "Clothing", fontSize: AppSize.width(value: 24), fontWeight: FontWeight.w600),
                    const Gap(height: 8),
                  ],
                ),
              ),

              SliverToBoxAdapter(
                child: VendorCategoriesWidget(
                  headerTitle: "Categories",
                  categories: wardrobe,
                  selectedCategoryIdProvider: vendorSelectedWardrobeCategoryProvider,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              if (isLoading)
                const SliverToBoxAdapter(
                  child: SizedBox(height: 440, child: Center(child: CircularProgressIndicator())),
                )
              else if (clothingProducts.isEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: AppText(
                        text: "No clothing products found",
                        style: TextStyle(fontSize: 18, color: AppColors.instance.black06),
                      ),
                    ),
                  ),
                )
              else if (clothingProducts.length <= 4)
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 214,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = clothingProducts[index];
                    return _buildProductCard(product);
                  }, childCount: clothingProducts.length),
                )
              else
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 440,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: clothingProducts.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 rows
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        mainAxisExtent: 195, // width of each item
                      ),
                      itemBuilder: (context, index) {
                        final product = clothingProducts[index];
                        return _buildProductCard(product);
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onDeleteProduct(int? productId) async {
    if (productId == null) return;

    final confirm = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(text: "Delete Product"),
        content: const AppText(text: "Are you sure you want to delete this product?"),
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
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return VendorAppBar(
      isButton: true,
      isBack: false,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const VendorAddProductScreen()));
      },
      title: "Store catalog",
    );
  }
}
