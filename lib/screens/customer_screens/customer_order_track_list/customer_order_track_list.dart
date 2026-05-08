import 'package:flutter/material.dart';
import 'package:nexprime/widgets/buttons/custom_decorated_box.dart';
import 'package:nexprime/widgets/buttons/icon_button_widget.dart';

import '../../../constant/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_size.dart';
import '../../../utils/gap.dart';
import '../../../widgets/texts/app_text.dart';

class CustomerOrderTrackList extends StatelessWidget {
  const CustomerOrderTrackList({super.key});

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
                    onTap: (){
                      AppRoutes.instance.pop();
                    },
                      icon: Icons.arrow_back),
                  Gap(width: AppSize.size.width * 0.02),
                  AppText(
                    text: 'Track order',
                    fontSize: AppSize.size.width * 0.055,
                    color: AppColors.instance.black06,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.04,
                  vertical: AppSize.size.height * 0.01,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: '24/2/2026',
                          fontSize: AppSize.size.width * 0.035,
                          color: AppColors.instance.gray400,
                        ),
                        Gap(height: AppSize.size.width * 0.011),
                        AppText(
                          text: '#798789',
                          fontSize: AppSize.size.width * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.instance.grayEE),
                      ),
                      child: SizedBox(
                        height: AppSize.size.height * 0.04,
                        width: AppSize.size.width * 0.18,
                        child: Center(child: AppText(text: 'shipped')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.size.width * 0.04,
                vertical: AppSize.size.height * 0.02,
              ),
              sliver: SliverList.builder(
                itemCount: _trackingData.length,
                itemBuilder: (context, index) {
                  final data = _trackingData[index];
                  return TrackItemWidget(
                    data: data,
                    isFirst: index == 0,
                    isLast: index == _trackingData.length - 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrackItemWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isFirst;
  final bool isLast;

  const TrackItemWidget({
    super.key,
    required this.data,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    bool isCompleted = data['isCompleted'] ?? false;
    Color statusColor = isCompleted
        ? AppColors.instance.green
        : AppColors.instance.gray200;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            if (!isLast)
              Positioned(
                left: AppSize.size.width * 0.08,
                top: AppSize.size.width * 0.08,
                bottom:
                    -AppSize.size.height * 0.02 -
                    (AppSize.size.width * 0.04),
                child: Container(
                  width: 1.5,
                  color: AppColors.instance.grayEE.withAlpha(160),
                ),
              ),
            CustomDecoratedBox(
              padding: EdgeInsets.zero,
              color: isCompleted
                  ? const Color(0xffF1F4F1)
                  : AppColors.instance.white200,
              child: Padding(
                padding: EdgeInsets.all(AppSize.size.width * 0.04),
                child: Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor.withAlpha(110),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusColor,
                          ),
                          child: SizedBox(
                            height: AppSize.size.width * 0.08,
                            width: AppSize.size.width * 0.08,
                            child: Center(
                              child: AppText(
                                text: data['step'] ?? '',
                                color: AppColors.instance.white100,
                                fontSize: AppSize.size.width * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gap(width: AppSize.size.width * 0.04),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: data['title'] ?? '',
                            fontSize: AppSize.size.width * 0.045,
                            fontWeight: FontWeight.w600,
                            color: AppColors.instance.black06,
                          ),
                          Gap(height: AppSize.size.height * 0.005),
                          AppText(
                            text: data['subtitle'] ?? '',
                            fontSize: AppSize.size.width * 0.035,
                            color: AppColors.instance.gray400,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Gap(height: AppSize.size.height * 0.02),
      ],
    );
  }
}

final List<Map<String, dynamic>> _trackingData = [
  {
    'step': '01',
    'title': 'Order place',
    'subtitle': 'Oct,25,2026',
    'isCompleted': true,
  },
  {
    'step': '02',
    'title': 'Processing',
    'subtitle': 'Oct,26,2026',
    'isCompleted': true,
  },
  {
    'step': '03',
    'title': 'Shipped',
    'subtitle': 'Oct,27,2026',
    'isCompleted': true,
  },
  {
    'step': '05',
    'title': 'Out for delivery',
    'subtitle': 'Upcoming',
    'isCompleted': false,
  },
  {
    'step': '05',
    'title': 'Delivered',
    'subtitle': 'Pending',
    'isCompleted': false,
  },
];
