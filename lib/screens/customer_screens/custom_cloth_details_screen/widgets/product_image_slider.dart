import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/screens/customer_screens/custom_cloth_details_screen/provider/page_provider.dart';
import 'package:nexprime/utils/app_size.dart';

import '../../../../widgets/buttons/icon_button_widget.dart';

class ProductImageSlider extends StatelessWidget {
  const ProductImageSlider({
    super.key,
    required PageController pageController,
    required this.ref,
    required this.imageUrls,
    required this.currentPage,
  }) : _pageController = pageController;

  final PageController _pageController;
  final WidgetRef ref;
  final List<String> imageUrls;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: AppSize.size.height * 0.35,
      flexibleSpace: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              ref.read(pageProvider.notifier).changePage(index);
            },
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Image.network(imageUrls[index], fit: BoxFit.cover);
            },
          ),
          Positioned(
            top: 20,
            left: 20,
            child: IconButtonWidget(
              onTap: () {
                Navigator.pop(context);
              },
              icon: Icons.arrow_back,
            ),
          ),
          Positioned(
            left: 15,
            top: AppSize.size.height * 0.2,
            child: IconButtonWidget(
              onTap: () {
                ref.read(pageProvider.notifier).previousPage();
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: Icons.chevron_left,
            ),
          ),
          Positioned(
            right: 15,
            top: AppSize.size.height * 0.2,
            child: IconButtonWidget(
              onTap: () {
                ref.read(pageProvider.notifier).nextPage(imageUrls.length);

                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: Icons.chevron_right,
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(AppSize.size.width * 0.07),
        child: Stack(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color:  Color(0xFFF5F5F5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SizedBox(
                height: AppSize.size.width * 0.06,
                width: AppSize.size.width,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(imageUrls.length, (index) {
                  bool isActive = currentPage == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? AppColors.instance.green
                          : Colors.grey.withAlpha(170),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}