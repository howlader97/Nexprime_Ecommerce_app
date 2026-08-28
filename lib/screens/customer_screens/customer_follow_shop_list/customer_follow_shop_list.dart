import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_asserts_icons_path.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/screens/customer_screens/customer_follow_shop_list/provider/shoplist_provider.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image_circular.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/buttons/icon_button_widget.dart';

import '../../../constant/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/texts/app_text.dart';

class CustomerFollowShopList extends ConsumerWidget {
  const CustomerFollowShopList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shop = ref.watch(shopListProvider);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: ()async{
            ref.invalidate(shopListProvider);
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    IconButtonWidget(
                      onTap: () {
                        AppRoutes.instance.pop();
                      },
                      icon: Icons.arrow_back,
                    ),
                    Gap(width: AppSize.size.width * 0.02),
                    AppText(
                      text: "Following shops",
                      fontSize: AppSize.size.width * 0.055,
                      color: AppColors.instance.black06,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              shop.when(
                error: (err, stack) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(child: Text("Error: $err")),
                  ),
                ),
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                data: (shopList) {
                  if (shopList.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Text("No shops found"),
                    );
                  }
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.size.width * 0.035,
                    ),
                    sliver: SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.90,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: shopList.length,
                      itemBuilder: (context, index) {
                        final shopValue = shopList[index];
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.instance.grayEE,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                AppImageCircular(
                                  fit: BoxFit.cover,
                                  height: AppSize.size.height * 0.063,
                                  width: AppSize.size.width * 0.14,
                                  url: shopValue.photo.isNotEmpty
                                      ? shopValue.photo
                                      : null,
                                  path: AppAssertsIconsPath.instance.shopIcon,
                                ),
                                Gap(height: AppSize.size.height * 0.01),
                                AppText(
                                  text: shopValue.name,
                                  fontWeight: FontWeight.w500,
                                  fontSize: AppSize.size.width * 0.045,
                                ),
                                Gap(height: AppSize.size.height * 0.005),
                                AppText(
                                  text: shopValue.bio,
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.center,
                                  color: AppColors.instance.black06,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: AppSize.size.width * 0.035,
                                ),
                               Spacer(),
                                AppButton(
                                  onTap: (){
                                    AppRoutes.instance.pushNamed(AppRoutesKey.instance.customerShopScreen,extra:shopValue.id.toString());
                                  },
                                  height: AppSize.size.width * 0.09,
                                  backgroundColor: AppColors.instance.green,
                                  borderColor: AppColors.instance.green,
                                  title: "View Store",
                                  fontSize: AppSize.size.width * 0.042,
                                ),
                                Gap(height: AppSize.size.height * 0.009,)
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
