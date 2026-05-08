import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/screens/customer_screens/customer_groceries_home_categories/widgets/customer_groceries_home_categories_widgets.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/provider/groceries_country_provider.dart';
import 'package:nexprime/widgets/buttons/custom_app_bar.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/texts/app_text.dart';
import '../customer_my_product_screens/widgets/my_product_card.dart';
import 'provider/marketing_product_provider.dart';

class CustomerMarketplaceScreen extends ConsumerWidget {
  const CustomerMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subcategories = ref.watch(
      groceriesProvider("Marketplace Management"),
    );

    final marketingProducts = ref.watch(marketingProductProvider);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: ()async{
            ref.refresh(marketingProductProvider);
            ref.refresh(groceriesProvider("Marketplace Management"));
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: CustomAppBar(
                  backButton: () {
                    AppRoutes.instance.pop();
                  },
                  title: 'Marketplace',
                  buttonTitle: 'New Product',
                  textButton: () {
                    AppRoutes.instance.pushNamed(
                      AppRoutesKey.instance.customerNewProductList,
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: subcategories != null && subcategories.isNotEmpty?
                CustomerGroceriesHomeCategoriesWidgets(
                  headerTitle: 'Categories',
                  categories: subcategories,
                ):Center(child: AppText(text: "No category",color: Colors.black),)
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.size.width * 0.04,
                    vertical: AppSize.size.width * 0.02,
                  ),
                  child:AppText(
                    text: "Today’s pics",
                    fontSize: AppSize.size.width * 0.06,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.042,
                ),
                sliver: marketingProducts.when(
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
                            (product.images != null && product.images!.isNotEmpty)
                            ? product.images!.first
                            : 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=1026&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

                        return MyProductCard(
                          marketplace: true,
                          imageUrl: imageUrl,
                          title: product.name ?? 'Unknown',
                          price: '\$${product.price ?? 0}',
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
