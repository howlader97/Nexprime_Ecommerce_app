import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/models/groceries_country_model.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

class VendorCategoriesWidget extends ConsumerWidget {
  final String headerTitle;
  final List<GroceriesCountryModel>? categories;
  final StateProvider<int?> selectedCategoryIdProvider;

  const VendorCategoriesWidget({
    super.key,
    required this.headerTitle,
    required this.categories,
    required this.selectedCategoryIdProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);

    return Container(
      margin: const EdgeInsets.symmetric( vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F5),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText( text: 
            headerTitle,
            style: TextStyle(
              fontSize: AppSize.size.width * 0.055,
              fontWeight: FontWeight.bold,
              color: AppColors.instance.black06,
            ),
          ),
          const SizedBox(height: 12),
          if (categories == null)
            SizedBox(
              height: AppSize.size.width * 0.3,
              child: const Center(child: CircularProgressIndicator()),
            )
          else if (categories!.isEmpty)
            SizedBox(
              height: AppSize.size.width * 0.3,
              child: Center(
                  child: AppText( text: "No categories found",
                      style: TextStyle(color: AppColors.instance.black06))),
            )
          else
            SizedBox(
              height: AppSize.size.width * 0.3,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories!.length,
                itemBuilder: (context, index) {
                  final category = categories![index];
                  bool isSelected = selectedCategoryId == category.id;

                  return GestureDetector(
                    onTap: () {
                      if (!isSelected) {
                        ref.read(selectedCategoryIdProvider.notifier).state = category.id;
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.08)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AppImage(
                              width: AppSize.size.width * 0.18,
                              height: AppSize.size.width * 0.2,
                              url: category.image,
                            ),
                          ),
                          Gap(height: AppSize.size.width * 0.01),
                          AppText(
                            text: category.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            fontSize: AppSize.size.width * 0.035,
                            color: AppColors.instance.black400,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
