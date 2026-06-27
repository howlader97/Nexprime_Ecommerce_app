import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/screens/vendor_screens/vendor_home_screen/provider/vendor_home_screen_provider.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import 'package:nexprime/widgets/inputs/app_input_widget.dart';

import '../../../models/vendor_seven_days_dashboard_model.dart';
import '../../../models/vendor_today_dashborad_model.dart';
import '../../../widgets/buttons/app_dropdown_field.dart';
import '../../../widgets/custom_date_picker/custom_show_date_picker.dart';

class VendorHomeScreen extends ConsumerStatefulWidget {
  const VendorHomeScreen({super.key});

  static const List<String> title = [
    "Total Revenue",
    "Pending Orders",
    "Total Products",
    "Total followers",
  ];

  @override
  ConsumerState<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends ConsumerState<VendorHomeScreen> {
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(vendorHomeDropdownProvider, (previous, next) {
      if (next != 'custom') {
        _startDateController.clear();
        _endDateController.clear();
        ref.read(vendorHomeStartDateProvider.notifier).state = null;
        ref.read(vendorHomeEndDateProvider.notifier).state = null;
      }
    });

    final dashBoard = ref.watch(vendorDashboard);
    final selectedRange = ref.watch(vendorHomeDropdownProvider);

    final storeName = dashBoard.value is VendorTodayDashboardModel
        ? (dashBoard.value as VendorTodayDashboardModel).storeName
        : (dashBoard.value is VendorSevenDaysDashboardModel
        ? (dashBoard.value as VendorSevenDaysDashboardModel).storeName
        : 'N/A');

    // Get raw earnings list based on model type
    final List<dynamic> rawEarnings;
    if (dashBoard.value is VendorTodayDashboardModel) {
      rawEarnings =
          (dashBoard.value as VendorTodayDashboardModel).earningsOverTime;
    } else if (dashBoard.value is VendorSevenDaysDashboardModel) {
      rawEarnings =
          (dashBoard.value as VendorSevenDaysDashboardModel).earningsOverTime;
    } else {
      rawEarnings = [];
    }

    final List<GroupedChartData> chartData = [];
    if (selectedRange == 'today' || selectedRange == 'yesterday') {
      final labels = [
        "12-3 AM",
        "4-7 AM",
        "8-11 AM",
        "12-3 PM",
        "4-7 PM",
        "8-11 PM",
      ];
      for (int i = 0; i < 6; i++) {
        double sum = 0;
        for (int j = 0; j < 4; j++) {
          int index = i * 4 + j;
          if (index < rawEarnings.length) {
            sum += rawEarnings[index].earnings;
          }
        }
        chartData.add(GroupedChartData(day: labels[i], earnings: sum));
      }
    } else if (selectedRange == 'last_30_days' ||
        selectedRange == 'this_month' ||
        selectedRange == 'last_1_year' ||
        (selectedRange == 'custom' && rawEarnings.length > 7)) {
      final int N = rawEarnings.length;
      for (int i = 0; i < 6; i++) {
        double sum = 0;
        int startIdx = (i * N / 6.0).round();
        int endIdx = ((i + 1) * N / 6.0).round() - 1;
        if (startIdx < N) {
          if (endIdx >= N) {
            endIdx = N - 1;
          }
          for (int j = startIdx; j <= endIdx; j++) {
            sum += rawEarnings[j].earnings;
          }
          final String startLabel = rawEarnings[startIdx].day;
          final String endLabel = rawEarnings[endIdx].day;
          final String label = selectedRange == 'last_1_year'
              ? _getYearRangeLabel(startLabel, endLabel)
              : _getRangeLabel(startLabel, endLabel);
          chartData.add(GroupedChartData(day: label, earnings: sum));
        }
      }
    } else {
      for (var e in rawEarnings) {
        chartData.add(GroupedChartData(day: e.day, earnings: e.earnings));
      }
    }

    final double maxAmount = chartData.isNotEmpty
        ? chartData.map((e) => e.earnings).reduce((a, b) => a > b ? a : b)
        : 0;

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
                      final val = dashBoard.value;
                      final double earning = val is VendorTodayDashboardModel
                          ? val.totalEarnings
                          : (val is VendorSevenDaysDashboardModel
                          ? val.totalEarnings
                          : 0.0);
                      final int pendingOrders = val is VendorTodayDashboardModel
                          ? val.totalPendingOrders
                          : (val is VendorSevenDaysDashboardModel
                          ? val.totalPendingOrders
                          : 0);
                      final int catalogSize = val is VendorTodayDashboardModel
                          ? val.totalProducts
                          : (val is VendorSevenDaysDashboardModel
                          ? val.totalProducts
                          : 0);
                      final int storeRating = val is VendorTodayDashboardModel
                          ? val.totalFollowers
                          : (val is VendorSevenDaysDashboardModel
                          ? val.totalFollowers
                          : 0);
                      final List<num> value = [
                        earning,
                        pendingOrders,
                        catalogSize,
                        storeRating,
                      ];
                      return _buildContainer(
                        VendorHomeScreen.title[index],
                        value[index],
                        // comment[index],
                      );
                    },
                  ),
                  SizedBox(height: AppSize.size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText(
                        text: "Last sales trend",
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                      Gap(width: 4),
                      Expanded(
                        child: AppDropdownField(
                          provider: vendorHomeDropdownProvider,
                          options: const [
                            'today',
                            'yesterday',
                            'last_7_days',
                            'last_30_days',
                            'this_month',
                            'last_1_year',
                            'custom',
                          ],
                          hintText: "Select range",
                        ),
                      ),
                    ],
                  ),

                  if (selectedRange == 'custom') ...[
                    const Gap(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.width(value: 16.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppInputWidget(
                              controller: _startDateController,
                              readOnly: true,
                              textColor: AppColors.instance.black900,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 16,
                              ),
                              hintText: "Start date",
                              onTap: () {
                                DateTime initial = DateTime.now();
                                if (_startDateController.text.isNotEmpty) {
                                  try {
                                    initial = DateTime.parse(
                                      _startDateController.text,
                                    );
                                  } catch (_) {}
                                }
                                showCustomCalendarView(
                                  initialDate: initial,
                                  firstDate: DateTime(2020),
                                  context: context,
                                  onDateSelected: (date) {
                                    final formatted =
                                        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                                    _startDateController.text = formatted;
                                    ref
                                        .read(
                                      vendorHomeStartDateProvider
                                          .notifier,
                                    )
                                        .state =
                                        formatted;
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppInputWidget(
                              controller: _endDateController,
                              readOnly: true,
                              textColor: AppColors.instance.black900,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 16,
                              ),
                              hintText: "End date",
                              onTap: () {
                                DateTime initial = DateTime.now();
                                if (_endDateController.text.isNotEmpty) {
                                  try {
                                    initial = DateTime.parse(
                                      _endDateController.text,
                                    );
                                  } catch (_) {}
                                }
                                showCustomCalendarView(
                                  initialDate: initial,
                                  firstDate: DateTime(2020),
                                  context: context,
                                  onDateSelected: (date) {
                                    final formatted =
                                        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                                    _endDateController.text = formatted;
                                    ref
                                        .read(
                                      vendorHomeEndDateProvider
                                          .notifier,
                                    )
                                        .state =
                                        formatted;
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

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
                        children: chartData.map((item) {
                          double heightFactor = maxAmount == 0
                              ? 0
                              : (item.earnings / maxAmount).clamp(0.0, 1.0);

                          return Expanded(
                            child: Column(
                              children: [
                                AppText(
                                  text: "\$${item.earnings}",
                                  color: Colors.black,
                                  fontSize: 12,
                                  // maxLines: 1,
                                  // overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w400,
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
                                AppText(
                                  text:
                                  (selectedRange == 'today' ||
                                      selectedRange == 'yesterday' ||
                                      selectedRange == 'last_30_days' ||
                                      selectedRange == 'this_month' ||
                                      selectedRange == 'last_1_year' ||
                                      (selectedRange == 'custom' &&
                                          rawEarnings.length > 7))
                                      ? item.day
                                      : (item.day.length >= 3
                                      ? item.day.substring(0, 3)
                                      : item.day),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                    (selectedRange == 'last_30_days' ||
                                        selectedRange == 'this_month' ||
                                        selectedRange == 'last_1_year' ||
                                        (selectedRange == 'custom' &&
                                            rawEarnings.length > 7))
                                        ? 10
                                        : 10,
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
            const Gap(height: 12),
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
            const Gap(height: 8),
          ],
        ),
      ),
    );
  }
}

class GroupedChartData {
  final String day;
  final double earnings;

  GroupedChartData({required this.day, required this.earnings});
}

String _getRangeLabel(String start, String end) {
  final startParts = start.trim().split(' ');
  final endParts = end.trim().split(' ');
  if (startParts.length == 2 && endParts.length == 2) {
    final startDay = startParts[0];
    final startMonth = startParts[1];
    final endDay = endParts[0];
    final endMonth = endParts[1];
    if (startMonth.toLowerCase() == endMonth.toLowerCase()) {
      return "$startDay-$endDay $startMonth";
    } else {
      return "$startDay $startMonth-$endDay $endMonth";
    }
  }
  return "$start-$end";
}

String _getYearRangeLabel(String start, String end) {
  final startParts = start.trim().split(' ');
  final endParts = end.trim().split(' ');
  if (startParts.length == 2 && endParts.length == 2) {
    final startMonth = startParts[0];
    final startYear = startParts[1];
    final endMonth = endParts[0];
    final endYear = endParts[1];
    final shortStartYear = startYear.length >= 4
        ? startYear.substring(2)
        : startYear;
    final shortEndYear = endYear.length >= 4 ? endYear.substring(2) : endYear;
    if (startYear == endYear) {
      return "$startMonth-$endMonth '$shortStartYear";
    } else {
      return "$startMonth'$shortStartYear-$endMonth'$shortEndYear";
    }
  }
  return "$start-$end";
}
