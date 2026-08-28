import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/screens/customer_screens/customer_about_us_screen/provider/about_us_provider.dart';
import 'package:nexprime/utils/gap.dart';

import '../../../constant/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/buttons/custom_app_bar.dart';
import '../../../widgets/buttons/custom_decorated_box.dart';
import '../../../widgets/texts/app_text.dart';

class CustomerAboutUsScreen extends ConsumerWidget {
  const CustomerAboutUsScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final aboutUs = ref.watch(aboutUsProvider);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: CustomAppBar(
                backButton: () {
                  AppRoutes.instance.pop();
                },
                title: "About Us",
              ),
            ),
            SliverToBoxAdapter(
              child: CustomDecoratedBox(
                child: Padding(
                  padding: EdgeInsets.all(AppSize.size.width * 0.04),
                  child: aboutUs.when(
                    data: (about) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: about?.title ?? "About Us",
                          fontSize: AppSize.size.width * 0.044,
                          color: AppColors.instance.black06,
                          fontWeight: FontWeight.w600,
                        ),
                        Gap(height: AppSize.size.width * 0.015),
                        AppText(
                          text: about?.content ?? "No content available.",
                          fontSize: AppSize.size.width * 0.035,
                          color: AppColors.instance.black06,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    loading: () =>
                    const Center(child: CircularProgressIndicator()),
                    error: (e, st) => Center(child: AppText( text: e.toString())),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
