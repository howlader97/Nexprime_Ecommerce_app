import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/screens/customer_screens/customer_privacy_policy/provider/customer_privacy_policy_provider.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/buttons/custom_app_bar.dart';
import 'package:nexprime/widgets/buttons/custom_decorated_box.dart';

import '../../../constant/app_colors.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/texts/app_text.dart';

class CustomerPrivacyPolicy extends ConsumerWidget {
  const CustomerPrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacyAsync = ref.watch(privacyPolicyProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: CustomAppBar(
                backButton: () {
                  AppRoutes.instance.pop();
                },
                title: "Privacy & Policy",
              ),
            ),
            SliverToBoxAdapter(
              child: CustomDecoratedBox(
                child: Padding(
                  padding: EdgeInsets.all(AppSize.size.width * 0.04),
                  child: privacyAsync.when(
                    data: (privacy) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: privacy?.title ?? "Privacy & Policy",
                          fontSize: AppSize.size.width * 0.044,
                          color: AppColors.instance.black06,
                          fontWeight: FontWeight.w600,
                        ),
                        Gap(height: AppSize.size.width * 0.015),
                        AppText(
                          text: privacy?.content ?? "No content available.",
                          fontSize: AppSize.size.width * 0.035,
                          color: AppColors.instance.black06,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, st) => Center(child: Text(e.toString())),
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
