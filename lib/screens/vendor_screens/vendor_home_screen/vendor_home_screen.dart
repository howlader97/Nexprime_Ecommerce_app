import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/screens/vendor_screens/vendor_home_screen/provider/vendor_home_screen_provider.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

class VendorHomeScreen extends ConsumerWidget {
  const VendorHomeScreen({super.key});

  static const List<String> title = [
    "Total Revenue",
    "Pending Orders",
    "Total Products",
    "Total followers",
  ];

  // static const List<String> comment = [
  //   "+12.5%",
  //   "+2 new",
  //   "Items",
  //   "Excellent",
  // ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashBoard = ref.watch(vendorDashboard);
    final salesData = dashBoard.value?.last7DaysEarnings ?? [];
    final double maxAmount = salesData.isNotEmpty
        ? salesData.map((e) => e.earnings).reduce((a, b) => a > b ? a : b)
        : 0;
    final storeName = dashBoard.value?.storeName ?? 'N/A';

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSize.size.height * 0.01,
                horizontal: AppSize.size.width * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "Hello, $storeName",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Your store ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color: AppColors.instance.black900,
                          ),
                        ),
                        TextSpan(
                          text: "$storeName ",
                          style: TextStyle(
                            color: AppColors.instance.green,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: "is performing great today.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color: AppColors.instance.black900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSize.size.height * 0.02),
                  GridView.builder(
                    itemCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 2,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final earning = dashBoard.value?.totalEarnings ?? 0;
                      final pendingOrders =
                          dashBoard.value?.totalPendingOrders ?? 0;
                      final catalogSize = dashBoard.value?.totalProducts ?? 0;
                      final storeRating = dashBoard.value?.totalFollowers ?? 0;
                      final List<num> value = [
                        earning,
                        pendingOrders,
                        catalogSize,
                        storeRating,
                      ];
                      return _buildContainer(
                        title[index],
                        value[index],
                        // comment[index],
                      );
                    },
                  ),
                  SizedBox(height: AppSize.size.height * 0.01),
                  const AppText(
                    text: "Last sales trend",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: AppSize.size.height * 0.010,
                    ),
                    width: AppSize.size.width,
                    height: 220,
                    decoration: BoxDecoration(
                      color: AppColors.instance.dark50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSize.size.height * 0.03,
                        horizontal: AppSize.size.width * 0.03,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: salesData.map((item) {
                          double heightFactor = maxAmount == 0
                              ? 0
                              : (item.earnings / maxAmount).clamp(0.0, 1.0);

                          return Expanded(
                            child: Column(
                              children: [
                                AppText( text:
                                "\$${item.earnings} k",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: FractionallySizedBox(
                                      heightFactor: heightFactor,
                                      child: Container(
                                        width: 34,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            topRight: Radius.circular(4),
                                          ),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xFFB9DFBE),
                                              Color(0xFF2E7D32),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                AppText( text:
                                item.day.length >= 3
                                    ? item.day.substring(0, 3)
                                    : item.day,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildContainer(
      final String title,
      final num value,
      // final String comment,
      ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSize.size.height * 0.010),
      decoration: BoxDecoration(
        color: AppColors.instance.dark50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.size.height * 0.03,
          horizontal: AppSize.size.width * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AppText(
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
            const Gap(height: 12,),
            SizedBox(
              width: double.infinity,
              child: AppText(
                text: value.toString(),
                fontSize: 24,
                fontWeight: FontWeight.w600,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                height: 1.5,
                color: Colors.green,
              ),
            ),
            const Gap(height: 8,),
            // Center(
            //   child: AppText(
            //     text: comment,
            //     fontSize: 12,
            //     fontWeight: FontWeight.w500,
            //     height: 1.5,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
