import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/provider/nav_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/provider/customer_home_screen_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/widgets/customer_home_banner.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/widgets/customer_home_country_card.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/widgets/customer_home_marketplace_widget.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/widgets/customer_home_search_bar.dart';
import 'package:nexprime/screens/customer_screens/customer_profile_screen/provider/customer_profile_provider.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../widgets/buttons/icon_button_widget.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/provider/groceries_country_provider.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
  // Future<void> _onRefresh() async {
  //   ref.invalidate(bannerProvider);
  //    ref.invalidate(groceriesProvider("Grocery Country"));
  //   await Future.wait([
  //     ref.read(customerProfileProvider.notifier).fetchProfile(),

  //     ref.read(groceriesProvider("Wardrobe Country").notifier).fetchCountries(),
  //   ]);
  // }

  Future<void> _onRefresh() async {
    try {
      ref.invalidate(customerProfileProvider);
      ref.invalidate(bannerProvider);
      ref.invalidate(groceriesProvider("Grocery Country"));
      ref.invalidate(groceriesProvider("Wardrobe Country"));
    } catch (e) {
      // Handle any errors that occur during the refresh
      appLog('Error refreshing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(customerProfileProvider);
    final banners = ref.watch(bannerProvider);

    final groceriesCountries = ref.watch(groceriesProvider("Grocery Country"));
    final wardrobeCountries = ref.watch(groceriesProvider("Wardrobe Country"));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                title: Skeletonizer(
                  enabled: profile.asData == null,
                  child: Row(
                    children: [
                      IconButtonWidget(icon: Icons.location_on_outlined, padding: AppSize.size.width * 0.018),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(text: "Deliver to", fontWeight: FontWeight.w400, color: AppColors.instance.black400, fontSize: 14),
                            AppText(
                              text: (profile.value?.location?.trim().isNotEmpty ?? false) ? (profile.value?.location ?? 'Japan') : 'Japan',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              color: AppColors.instance.primary,
                              fontSize: 16,
                            ),
                          ],
                        ),
                      ),
                      IconButtonWidget(
                        padding: AppSize.size.width * 0.018,
                        onTap: () {
                          AppRoutes.instance.pushNamed(AppRoutesKey.instance.customerNotificationScreen);
                        },
                        icon: Icons.notifications_none_outlined,
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.04, vertical: AppSize.size.width * 0.017),
                  child: CustomSearchBar(
                    controller: _searchController,
                    onSearchTap: () {
                      if (_searchController.text.isNotEmpty) {
                        ref.read(searchQueryProvider.notifier).state = _searchController.text;
                        _searchController.clear();
                        ref.read(navIndexProvider.notifier).state = 1;
                      }
                    },
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        ref.read(searchQueryProvider.notifier).state = value;
                        _searchController.clear();
                        ref.read(navIndexProvider.notifier).state = 1;
                      }
                    },
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
                  child: banners.when(
                    data: (data) {
                      final imageList = data.map((e) => e.imageUrl).toList();
                      return CustomerHomeBanner(images: imageList, height: AppSize.size.height * 0.185);
                    },
                    error: (error, stackTrace) {
                      return SizedBox(
                        height: AppSize.size.height * 0.185,
                        child: const Center(child: AppText(text: 'No banners found')),
                      );
                    },
                    loading: () {
                      return Skeletonizer(
                        enabled: true,
                        child: CustomerHomeBanner(
                          images: [
                            "https://static.vecteezy.com/system/resources/thumbnails/023/009/485/small_2x/abstract-animal-owl-portrait-with-colorful-double-exposure-paint-with-generative-ai-free-photo.jpeg",
                            "https://static.vecteezy.com/system/resources/thumbnails/023/009/485/small_2x/abstract-animal-owl-portrait-with-colorful-double-exposure-paint-with-generative-ai-free-photo.jpeg",
                            "https://static.vecteezy.com/system/resources/thumbnails/023/009/485/small_2x/abstract-animal-owl-portrait-with-colorful-double-exposure-paint-with-generative-ai-free-photo.jpeg",
                            "https://static.vecteezy.com/system/resources/thumbnails/023/009/485/small_2x/abstract-animal-owl-portrait-with-colorful-double-exposure-paint-with-generative-ai-free-photo.jpeg",
                            "https://static.vecteezy.com/system/resources/thumbnails/023/009/485/small_2x/abstract-animal-owl-portrait-with-colorful-double-exposure-paint-with-generative-ai-free-photo.jpeg",
                          ],
                          height: AppSize.size.height * 0.185,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: CustomerHomeMarketplaceWidget(
                  onTap: () {
                    AppRoutes.instance.pushNamed(AppRoutesKey.instance.customerMarketplaceScreen);
                  },
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(color: AppColors.instance.grayEE, borderRadius: BorderRadius.circular(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'Groceries by Country',
                          style: TextStyle(fontSize: AppSize.size.width * 0.054, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 11),
                        SizedBox(
                          height: AppSize.height(value: 100),
                          child: groceriesCountries == null
                              ? Skeletonizer(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      return CustomerHomeCountryCard(
                                        onTap: () {},
                                        image:
                                            "https://static.vecteezy.com/system/resources/thumbnails/023/009/485/small_2x/abstract-animal-owl-portrait-with-colorful-double-exposure-paint-with-generative-ai-free-photo.jpeg",
                                        title: 'Country Name',
                                      );
                                    },
                                  ),
                                )
                              : groceriesCountries.isEmpty
                              ? const Center(child: AppText(text: 'No groceries countries found'))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: groceriesCountries.length,
                                  itemBuilder: (context, index) {
                                    final country = groceriesCountries[index];
                                    return CustomerHomeCountryCard(
                                      onTap: () {
                                        AppRoutes.instance.pushNamed(
                                          AppRoutesKey.instance.customerGroceriesHomeCategories,
                                          pathParameters: {'id': country.id.toString(), 'name': country.name},
                                        );
                                      },
                                      image: country.image,
                                      title: country.name,
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(color: AppColors.instance.grayEE, borderRadius: BorderRadius.circular(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'Wardrobe by Country',
                          style: TextStyle(fontSize: AppSize.size.width * 0.054, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 11),
                        SizedBox(
                          height: AppSize.height(value: 100),
                          child: wardrobeCountries == null
                              ? Skeletonizer(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      return CustomerHomeCountryCard(
                                        onTap: () {},
                                        image:
                                            "https://static.vecteezy.com/system/resources/thumbnails/023/009/485/small_2x/abstract-animal-owl-portrait-with-colorful-double-exposure-paint-with-generative-ai-free-photo.jpeg",
                                        title: 'Country Name',
                                      );
                                    },
                                  ),
                                )
                              : wardrobeCountries.isEmpty
                              ? const Center(child: AppText(text: 'No wardrobe countries found'))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: wardrobeCountries.length,
                                  itemBuilder: (context, index) {
                                    final country = wardrobeCountries[index];
                                    return CustomerHomeCountryCard(
                                      onTap: () {
                                        AppRoutes.instance.pushNamed(
                                          AppRoutesKey.instance.customerClothScreen,
                                          pathParameters: {'id': country.id.toString(), 'name': country.name},
                                        );
                                      },
                                      image: country.image,
                                      title: country.name,
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 5)),
            ],
          ),
        ),
      ),
    );
  }
}
