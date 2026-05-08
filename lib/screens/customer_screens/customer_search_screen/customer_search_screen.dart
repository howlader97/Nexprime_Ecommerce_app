import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/models/product_model.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/provider/nav_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_search_screen/provider/product_search_provider.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../../utils/gap.dart';
import '../customer_home_screen/widgets/customer_home_search_bar.dart';

class CustomerSearchScreen extends ConsumerStatefulWidget {
  final String query;
  const CustomerSearchScreen({super.key, this.query = ''});

  @override
  ConsumerState<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends ConsumerState<CustomerSearchScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialQuery = ref.read(searchQueryProvider);
      if (initialQuery.isNotEmpty) {
        _searchController.text = initialQuery;
        ref.read(productSearchProvider.notifier).search(initialQuery);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(productSearchProvider);

    // Listen to global search query changes (e.g. from Home Screen)
    ref.listen(searchQueryProvider, (previous, next) {
      if (next.isNotEmpty && next != _searchController.text) {
        _searchController.text = next;
        ref.read(productSearchProvider.notifier).search(next);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppSize.size.width * 0.04),
                child: CustomSearchBar(
                  controller: _searchController,
                  showLastIcon: _searchController.text.isNotEmpty,
                  onLastIconTap: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      ref.read(productSearchProvider.notifier).search(value);
                    }
                  },
                  onSearchTap: () {
                    if (_searchController.text.isNotEmpty) {
                      ref.read(productSearchProvider.notifier).search(_searchController.text);
                    }
                  },
                ),
              ),
            ),
            searchState.when(
              data: (products) {
                if (products.isEmpty) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: AppText(
                        text: "No products matching with search data",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = products[index];
                        return ProductCard(product: product);
                      },
                      childCount: products.length,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.15,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (product.size.isEmpty && product.colors.isEmpty) {
          AppRoutes.instance.pushNamed(
            AppRoutesKey.instance.customerFoodDetailsScreen,
            extra: product,
          );
        } else {
          AppRoutes.instance.pushNamed(
            AppRoutesKey.instance.customerClothDetailsScreen,
            extra: product,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xffF2F5F2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.images.isNotEmpty
                    ? product.images.first
                    : 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=1000&auto=format&fit=crop',
                width: AppSize.size.width * 0.19,
                height: AppSize.size.height,
                fit: BoxFit.cover,
              ),
            ),
            Gap(width: AppSize.size.width * 0.013),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    fontSize: AppSize.size.width * 0.042,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  Gap(height: AppSize.size.width * 0.012),
                  AppText(
                    text: product.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    fontSize: AppSize.size.width * 0.033,
                    color: AppColors.instance.gray300,
                  ),
                  const Spacer(),
                  AppText(
                    text: "\$${product.salePrice}",
                    fontSize: AppSize.size.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  const Spacer(),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.instance.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
