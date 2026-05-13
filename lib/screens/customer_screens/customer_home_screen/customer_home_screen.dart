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
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../../widgets/buttons/icon_button_widget.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/provider/groceries_country_provider.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(customerProfileProvider);
    final banners = ref.watch(bannerProvider);
    final imageList = banners.map((e) => e.imageUrl).toList();
    final groceriesCountries =
        ref.watch(groceriesProvider("Grocery Country")) ?? [];
    final wardrobeCountries =
        ref.watch(groceriesProvider("Wardrobe Country")) ?? [];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  IconButtonWidget(icon: Icons.location_on_outlined,padding: AppSize.size.width * 0.018,),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   "Deliver to",
                        //   style: TextStyle(
                        //     fontSize: AppSize.size.width * 0.035,
                        //     color: AppColors.instance.black400,
                        //     fontWeight: FontWeight.w400,
                        //   ),
                        // ),
                        // Text(
                        //   "Tokyo, japan",
                        //   style: TextStyle(
                        //     fontSize: AppSize.size.width * 0.04,
                        //     color: AppColors.instance.primary,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        AppText(text: "Deliver to", fontWeight: FontWeight.w400,color: AppColors.instance.black400,fontSize: 14,),
                        AppText(text: profile?.locaion ?? 'location', fontWeight: FontWeight.bold,color: AppColors.instance.primary,fontSize: 16,),
                      ],
                    ),
                  ),
                  IconButtonWidget(
                     padding: AppSize.size.width * 0.018,
                    onTap: () {
                      AppRoutes.instance.pushNamed(
                        AppRoutesKey.instance.customerNotificationScreen,
                      );
                    },
                    icon: Icons.notifications_none_outlined,
                  ),
                ],
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:  AppSize.size.width * 0.04,vertical: AppSize.size.width * 0.017),
                child: CustomSearchBar(
                  controller: _searchController,
                  onSearchTap: () {
                    if (_searchController.text.isNotEmpty) {
                      ref.read(searchQueryProvider.notifier).state =
                          _searchController.text;
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 2),
                child: banners.isEmpty
                    ?  SizedBox(
                        height: AppSize.size.height * 0.185,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : CustomerHomeBanner(images: imageList,height: AppSize.size.height * 0.185,),
              ),
            ),

            SliverToBoxAdapter(
              child: CustomerHomeMarketplaceWidget(
                onTap: () {
                  AppRoutes.instance.pushNamed(
                    AppRoutesKey.instance.customerMarketplaceScreen,
                  );
                },
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.instance.grayEE,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText( text:'Groceries by Country',
                        style: TextStyle(
                          fontSize: AppSize.size.width * 0.054,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 11),
                      SizedBox(
                        height: AppSize.height(value: 100),
                        child: groceriesCountries.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: groceriesCountries.length,
                                itemBuilder: (context, index) {
                                  final country = groceriesCountries[index];
                                  return CustomerHomeCountryCard(
                                    onTap: () {
                                      AppRoutes.instance.pushNamed(
                                        AppRoutesKey
                                            .instance
                                            .customerGroceriesHomeCategories,
                                        pathParameters: {
                                          'id': country.id.toString(),
                                          'name': country.name,
                                        },
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.instance.grayEE,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                       text: 'Wardrobe by Country',
                        style: TextStyle(
                          fontSize: AppSize.size.width * 0.054,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 11),
                      SizedBox(
                        height: AppSize.height(value: 100),
                        child: wardrobeCountries.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: wardrobeCountries.length,
                                itemBuilder: (context, index) {
                                  final country = wardrobeCountries[index];
                                  return CustomerHomeCountryCard(
                                    onTap: () {
                                      AppRoutes.instance.pushNamed(
                                        AppRoutesKey
                                            .instance
                                            .customerClothScreen,
                                        pathParameters: {
                                          'id': country.id.toString(),
                                          'name': country.name,
                                        },
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
            SliverToBoxAdapter(child: SizedBox(height: 5,),),
          ],
        ),
      ),
    );
  }
}
