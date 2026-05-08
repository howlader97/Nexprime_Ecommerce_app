import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/buttons/custom_app_bar.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import 'package:nexprime/screens/customer_screens/customer_food_details_screen/provider/review_provider.dart';

class CustomerReviewListScreen extends ConsumerWidget {
  final int productId;
  const CustomerReviewListScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewAsync = ref.watch(reviewProvider(productId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: CustomAppBar(
                backButton: () {
                  AppRoutes.instance.pop();
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.04,
                  vertical: AppSize.size.height * 0.01,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Rating & Reviews",
                      fontSize: AppSize.size.width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.instance.black500,
                    ),
                    Gap(height: AppSize.size.height * 0.005),
                  ],
                ),
              ),
            ),
            reviewAsync.when(
              data: (reviews) {
                if (reviews.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: AppText(text: "No reviews yet."),
                    ),
                  );
                }
                return SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.size.width * 0.045,
                    vertical: AppSize.size.height * 0.01,
                  ),
                  sliver: SliverList.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      // Simple manual date formatting: YYYY-MM-DD
                      final dateStr = "${review.createdAt.year}-${review.createdAt.month.toString().padLeft(2, '0')}-${review.createdAt.day.toString().padLeft(2, '0')}";

                      return Padding(
                        padding: EdgeInsets.only(bottom: AppSize.size.height * 0.025),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: AppSize.size.width * 0.12,
                                  height: AppSize.size.width * 0.12,
                                  decoration: BoxDecoration(
                                    color: AppColors.instance.green.withAlpha(50),
                                    shape: BoxShape.circle,
                                    image: review.user.profileImageUrl.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(review.user.profileImageUrl),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: review.user.profileImageUrl.isEmpty
                                      ? Center(
                                          child: AppText(
                                            text: review.user.fullname.isNotEmpty
                                                ? review.user.fullname[0].toUpperCase()
                                                : "?",
                                            fontSize: AppSize.size.width * 0.05,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.instance.green,
                                          ),
                                        )
                                      : null,
                                ),
                                Gap(width: AppSize.size.width * 0.03),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppText(
                                            text: review.user.fullname.isNotEmpty
                                                ? review.user.fullname
                                                : "Anonymous",
                                            fontSize: AppSize.size.width * 0.042,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.instance.black06,
                                          ),
                                          AppText(
                                            text: dateStr,
                                            fontSize: AppSize.size.width * 0.03,
                                            color: AppColors.instance.gray50,
                                          ),
                                        ],
                                      ),
                                      Gap(height: AppSize.size.height * 0.005),
                                      Row(
                                        children: List.generate(5, (starIndex) {
                                          return Icon(
                                            Icons.star_rounded,
                                            size: AppSize.size.width * 0.045,
                                            color: starIndex < review.score
                                                ? AppColors.instance.yellow
                                                : AppColors.instance.gray400,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Gap(height: AppSize.size.height * 0.012),
                            AppText(
                              text: review.review,
                              fontSize: AppSize.size.width * 0.035,
                              color: AppColors.instance.black06,
                              maxLines: 4,
                            ),
                            Gap(height: AppSize.size.height * 0.02),
                            Divider(
                              color: AppColors.instance.gray50.withAlpha(70),
                              thickness: 1,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => SliverFillRemaining(
                child: Center(
                  child: AppText(text: "Error loading reviews: $error"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
