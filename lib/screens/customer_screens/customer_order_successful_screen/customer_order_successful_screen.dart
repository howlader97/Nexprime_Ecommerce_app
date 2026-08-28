import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import 'package:nexprime/provider/nav_provider.dart';

class CustomerOrderSuccessfulScreen extends ConsumerWidget {
  const CustomerOrderSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body:SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: AppSize.width(value: 16)),
                child: Column(
                  spacing: 10,

                  children: [
                    Gap(height: AppSize.size.height * 0.27,),
                    AppText(text: "Order Successful!",
                      fontSize: AppSize.size.width * 0.06,
                      fontWeight: FontWeight.w600,
                    ),
                     Padding(
                       padding:  EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.16),
                       child: AppText(text: "Arigato! Your items are being prepared. A confirmation email has been sent.",
                          fontSize: AppSize.size.width * 0.04,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w400,
                        ),
                     ),
                    // AppButton(
                    //   onTap: (){
                    //   // AppRoutes.instance.pushNamed(AppRoutesKey.instance.customerOrderScreen);
                    //   },
                    //   height: AppSize.size.height* 0.052,
                    //   title: "Track My Order",
                    //   backgroundColor: AppColors.instance.green,
                    //   borderColor: AppColors.instance.green,
                    // ),
                    AppButton(
                      onTap: (){
                        ref.read(navIndexProvider.notifier).state = 0;
                        AppRoutes.instance.go(AppRoutesKey.instance.appNavigationScreen);
                      },
                      height: AppSize.size.height* 0.052,
                      title: "Continue Shopping",
                      titleColor:AppColors.instance.black06,
                      backgroundColor: AppColors.instance.white50,
                      borderColor: AppColors.instance.black06,),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
