import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nexprime/screens/vendor_screens/vendor_product_screen/widgets/vendor_product_app_bar.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image_circular.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

class VendorReviewScreen extends StatelessWidget {
  const VendorReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: Padding(
              padding: EdgeInsets.only(left: AppSize.size.width * 0.05),
              child: VendorAppBar(title: ""),
            )),
            SliverList.builder(itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            AppImageCircular(
                              path:
                              "assets/dev_image/vendor_profile_image.png",
                              height: AppSize.size.height * 0.05,
                              width: AppSize.size.width * 0.11,
                            ),
                            Gap(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: "  Eleanor Summers",
                                  fontWeight: FontWeight.w600,
                                ),
                                RatingBar.builder(
                                  initialRating: 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(
                                    horizontal: 1,
                                  ),
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  onRatingUpdate: (rating) {
                                    appLog(rating);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        AppText(text: "Today, 16:40"),
                      ],
                    ),
                    AppText(
                      text:
                      "What can I say it's fast food, it's Burger King.No different to any of the other burger kings, nice with adequate seating",
                    ),
                    Divider()
                  ],
                ),
              ),
            ),)
          ],
        ),
      ),
    );
  }
}
