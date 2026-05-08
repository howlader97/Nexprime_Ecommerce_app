import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/screens/customer_screens/customer_marketplace/provider/marketing_product_provider.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../customer_profile_screen/provider/customer_profile_provider.dart';

final marketplaceProductPageProvider = StateProvider.autoDispose<int>((ref) => 0);

class CustomerMarketplaceProductDetails extends ConsumerStatefulWidget {
  final int productId;
  const CustomerMarketplaceProductDetails({super.key, required this.productId});

  @override
  ConsumerState<CustomerMarketplaceProductDetails> createState() =>
      _CustomerMarketplaceProductDetailsState();
}

class _CustomerMarketplaceProductDetailsState
    extends ConsumerState<CustomerMarketplaceProductDetails> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser=ref.watch(customerProfileProvider);
    final currentPage = ref.watch(marketplaceProductPageProvider);
    final productState = ref.watch(singleMarketingProductProvider(widget.productId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: productState.when(
          data: (product) {
            if (product == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      text: "Product not found",
                      fontSize: 16,
                    ),
                    const Gap(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.instance.green,
                      ),
                      onPressed: () => AppRoutes.instance.pop(),
                      child: const Text("Go Back", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            }

            final images = (product.images != null && product.images!.isNotEmpty)
                ? product.images!
                : [
                    'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500&auto=format&fit=crop&q=60'
                  ];

            return Stack(
              children: [
                // Top Section: Image Carousel
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: AppSize.size.height * 0.45,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          ref
                              .read(marketplaceProductPageProvider.notifier)
                              .state = index;
                        },
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            images[index],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Icon(Icons.error));
                            },
                          );
                        },
                      ),
                      // Left Arrow
                      Positioned(
                        top: AppSize.size.height * 0.2,
                        left: 16,
                        child: GestureDetector(
                          onTap: () {
                            if (currentPage > 0) {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.instance.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                      // Right Arrow
                      Positioned(
                        top: AppSize.size.height * 0.2,
                        right: 16,
                        child: GestureDetector(
                          onTap: () {
                            if (currentPage < images.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.instance.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                      // Dots Indicator
                      Positioned(
                        bottom: AppSize.size.height * 0.05,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            images.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentPage == index
                                    ? AppColors.instance.green
                                    : const Color(0xFF4A4A4A),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom Section: Details
                Positioned(
                  top: AppSize.size.height * 0.42,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFF1F0), // Light greyish green from image
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: product.goodsType ?? "Category",
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                                const Gap(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: AppText(
                                        text: product.name ?? 'Unknown Product',
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: AppColors.instance.green,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: AppText(
                                        text: "\$${product.price ?? '0.00'}",
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(height: 16),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: AppColors.instance.green,
                                      size: 20,
                                    ),
                                    const Gap(width: 4),
                                    AppText(
                                      text: product.location ?? 'Unknown Location',
                                      color: AppColors.instance.green,
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
                                const Gap(height: 24),
                                AppText(
                                  text: "Description",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                const Gap(height: 12),
                                AppText(
                                  text: product.description != null && product.description!.isNotEmpty
                                      ? product.description!
                                      : "No description available.",
                                  color: Colors.grey.shade700,
                                  height: 1.5,
                                  fontSize: 14,
                                  maxLines: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: AppButton(
                            height: AppSize.size.height * 0.065,
                            title: product.creatorId == currentUser?.id ?"Owner Product": "Message Seller",
                            onTap: () {
                              if(product.creatorId == currentUser?.id){
                                return ;
                              }
                              AppRoutes.instance.pushNamed(AppRoutesKey.instance.customerChatScreen, extra: {
                                "userId": product.creatorId,
                                "name": product.creator?.fullname,
                                "profileImageUrl": product.creator?.profileImageUrl,
                                "product": product,
                                "showReport":true,
                              });
                            },

                            backgroundColor: AppColors.instance.green,
                            borderColor: AppColors.instance.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Back Button
                Positioned(
                  top: 16,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => AppRoutes.instance.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.instance.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  text: "Failed to load product",
                  fontSize: 16,
                ),
                const Gap(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.instance.green,
                  ),
                  onPressed: () => ref.refresh(singleMarketingProductProvider(widget.productId)),
                  child: const Text("Retry", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

