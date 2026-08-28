import 'package:flutter/material.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/buttons/custom_decorated_box.dart';
import 'package:nexprime/widgets/buttons/icon_button_widget.dart';
import 'package:nexprime/routes/app_routes.dart';

import '../../../constant/app_colors.dart';
import '../../../utils/app_size.dart';
import '../../../utils/gap.dart';
import '../../../widgets/texts/app_text.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'provider/customer_review_provider.dart';

class CustomerReviewScreen extends ConsumerStatefulWidget {
  final int orderId;
  const CustomerReviewScreen({super.key, required this.orderId});

  @override
  ConsumerState<CustomerReviewScreen> createState() => _CustomerReviewScreenState();
}

class _CustomerReviewScreenState extends ConsumerState<CustomerReviewScreen> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: 'How was your experience?',
                      fontSize: AppSize.size.width * 0.065,
                      fontWeight: FontWeight.bold,
                      color: AppColors.instance.black06,
                    ),
                    Gap(height: AppSize.size.height * 0.01),
                    AppText(
                      text:
                          'Your review helps other customers and our\noperators.',
                      fontSize: AppSize.size.width * 0.045,
                      color: AppColors.instance.gray50,
                    ),
                    Gap(height: AppSize.size.height * 0.04),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: 'Rate this product',
                      fontSize: AppSize.size.width * 0.045,
                      fontWeight: FontWeight.w600,
                      color: AppColors.instance.black06,
                    ),
                    Gap(height: AppSize.size.height * 0.01),
                    Row(
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _rating = index + 1;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: AppSize.size.width * 0.02,
                            ),
                            child: Icon(
                              Icons.star_rounded,
                              size: AppSize.size.width * 0.12,
                              color: index < _rating
                                  ? AppColors.instance.yellow
                                  : AppColors.instance.gray400,
                            ),
                          ),
                        );
                      }),
                    ),
                    Gap(height: AppSize.size.height * 0.04),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.04,
                ),
                child: AppText(
                  text: 'Review',
                  fontSize: AppSize.size.width * 0.045,
                  fontWeight: FontWeight.w600,
                  color: AppColors.instance.black06,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CustomDecoratedBox(
                height: AppSize.size.width * 0.41,
                child: TextField(
                  controller: _reviewController,
                  maxLines: 6,
                  style: TextStyle(color: AppColors.instance.black06),
                  decoration: InputDecoration(
                    hintText: 'write here',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSize.size.width * 0.04,
                      vertical: AppSize.size.width * 0.02,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal:  AppSize.size.width * 0.038),
                  child: AppButton(
                    onTap: () {
                      ref.read(customerReviewProvider.notifier).submitReview(
                            score: _rating,
                            reviewText: _reviewController.text.trim(),
                            orderId: widget.orderId,
                          );
                    },
                    height:  AppSize.size.width * 0.12,
                    backgroundColor:  AppColors.instance.green,
                    borderColor:  AppColors.instance.green,
                    title: ref.watch(customerReviewProvider).isLoading ? 'Loading...' : 'Submit',
                  ),
                ),),
          ],
        ),
      ),
    );
  }
}
