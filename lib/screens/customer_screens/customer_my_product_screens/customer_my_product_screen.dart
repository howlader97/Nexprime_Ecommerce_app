import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/screens/customer_screens/customer_my_product_screens/widgets/my_product_card.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/buttons/icon_button_widget.dart';

import '../../../constant/app_colors.dart';
import '../../../routes/app_routes_key.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/texts/app_text.dart';
import 'package:nexprime/services/repository/marketing_product_repository.dart';
import 'package:nexprime/utils/app_snack_bar.dart';
import 'provider/my_marketing_product_provider.dart';

class CustomerMyProductScreen extends ConsumerWidget {
  const CustomerMyProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myProductsAsync = ref.watch(myMarketingProductProvider);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: ()async{
            ref.refresh(myMarketingProductProvider);
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.size.width * 0.042,
                    vertical: AppSize.size.width * 0.04,
                  ),
                  child: Row(
                    children: [
                      IconButtonWidget(
                        onTap: (){
                          AppRoutes.instance.pop();
                        },
                          icon: Icons.arrow_back),
                      Gap(width: AppSize.size.width * 0.03),
                      AppText(
                        text: "My Product",
                        fontSize: AppSize.size.width * 0.055,
                        color: AppColors.instance.black06,
                        fontWeight: FontWeight.w600,
                      ),
                      Gap(width: AppSize.size.width * 0.16),
                      AppButton(
                        onTap: (){
                          AppRoutes.instance.pushNamed(
                            AppRoutesKey.instance.customerNewProductList,
                          );
                        },
                        title: "New Product",
                        fontSize: AppSize.size.width * 0.038,
                        backgroundColor: AppColors.instance.green,
                        borderColor: AppColors.instance.green,
                        width: AppSize.size.width * 0.3,
                        height: AppSize.size.width * 0.1,
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.042,
                ),
                sliver: myProductsAsync.when(
                  data: (products) {
                    if (products.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: AppText(
                            text: "No products available",
                            fontSize: AppSize.size.width * 0.04,
                          ),
                        ),
                      );
                    }
                    return SliverGrid.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final imageUrl = (product.images != null && product.images!.isNotEmpty)
                            ? product.images!.first
                            : 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=1026&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

                        return MyProductCard(
                          imageUrl: imageUrl,
                          title: product.name ?? 'Unknown',
                          price: '\$${product.price ?? 0}',
                          onEdit: () {
                            AppRoutes.instance.pushNamed(
                              AppRoutesKey.instance.customerNewProductList,
                              extra: product,
                            );
                          },
                          onDelete: () async {
                            final confirm = await showAdaptiveDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const AppText( text: "Delete Product",style: TextStyle(color: Colors.black),),
                                content: const AppText( text: 
                                  "Are you sure you want to delete this product?",style: TextStyle(color:Colors.black),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const AppText( text: "Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const AppText( text: 
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              final success = await MarketingProductRepository
                                  .instance
                                  .deleteMarketingProduct(product.id!);
                              if (success) {
                                AppSnackBar.instance
                                    .success("Product deleted successfully");
                                ref.invalidate(myMarketingProductProvider);
                              } else {
                                AppSnackBar.instance
                                    .error("Failed to delete product");
                              }
                            }
                          },
                        );
                      },
                    );
                  },
                  error: (error, stack) => SliverToBoxAdapter(
                    child: Center(
                      child: AppText(
                        text: "Error loading my products",
                        fontSize: AppSize.size.width * 0.04,
                      ),
                    ),
                  ),
                  loading: () => const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
