import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/screens/customer_screens/customer_terms_conditions/provider/customer_terms_conditions_provider.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/buttons/custom_decorated_box.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../../routes/app_routes.dart';
import '../../../widgets/buttons/custom_app_bar.dart';

class CustomerTermsConditions extends ConsumerWidget {
  const CustomerTermsConditions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termsAsync = ref.watch(termsAndConditionsProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: CustomAppBar(
                backButton: () {
                  AppRoutes.instance.pop();
                },
                title: "Terms & conditions",
              ),
            ),
            SliverToBoxAdapter(
              child: CustomDecoratedBox(
                child: Padding(
                  padding: EdgeInsets.all(AppSize.size.width * 0.04),
                  child: termsAsync.when(
                    data: (terms) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: terms?.title ?? "Terms & conditions",
                          fontSize: AppSize.size.width * 0.044,
                          color: AppColors.instance.black06,
                          fontWeight: FontWeight.w600,
                        ),
                        Gap(height: AppSize.size.width * 0.015),
                        AppText(
                          text: terms?.content ?? "No content available.",
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
