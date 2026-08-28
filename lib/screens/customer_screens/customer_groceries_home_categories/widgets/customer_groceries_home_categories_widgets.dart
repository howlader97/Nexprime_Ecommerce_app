import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/screens/customer_screens/customer_groceries_home_categories/provider/product_provider.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/models/groceries_country_model.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

class CustomerGroceriesHomeCategoriesWidgets extends ConsumerStatefulWidget {
  final String headerTitle;
  final List<GroceriesCountryModel>? categories;
  final int? countryId;
  final Function(int? categoryId)? onTapCategory;
  // Marketplace-specific: fires with category name (null = toggled off)
  final Function(String? categoryName)? onTapCategoryName;

  const CustomerGroceriesHomeCategoriesWidgets({super.key, required this.headerTitle, required this.categories, this.countryId, this.onTapCategory, this.onTapCategoryName});

  @override
  ConsumerState<CustomerGroceriesHomeCategoriesWidgets> createState() => _CustomerGroceriesHomeCategoriesWidgetsState();
}

class _CustomerGroceriesHomeCategoriesWidgetsState extends ConsumerState<CustomerGroceriesHomeCategoriesWidgets> {
  int? selectedCategoryId;

  void selectCategory(int id, {String? name}) {
    // --- onTapCategoryName (marketplace name-based filter) ---
    if (widget.onTapCategoryName != null) {
      if (selectedCategoryId == id) {
        setState(() {
          selectedCategoryId = null;
        });
        widget.onTapCategoryName!(null);
      } else {
        setState(() {
          selectedCategoryId = id;
        });
        widget.onTapCategoryName!(name);
      }
      return;
    }
    // --- onTapCategory (id-based, original behavior) ---
    if (widget.onTapCategory != null) {
      if (selectedCategoryId == id) {
        setState(() {
          selectedCategoryId = null;
        });
        widget.onTapCategory!(null);
      } else {
        setState(() {
          selectedCategoryId = id;
        });
        widget.onTapCategory!(id);
      }
      return;
    }
    // --- countryId-based (grocery screen, original behavior) ---
    if (widget.countryId == null) return;
    if (selectedCategoryId == id) {
      setState(() {
        selectedCategoryId = null;
      });
      ref.read(productProvider(widget.countryId!).notifier).getProduct(clearCategory: true);
    } else {
      setState(() {
        selectedCategoryId = id;
      });
      ref.read(productProvider(widget.countryId!).notifier).getProduct(categoryId: id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20).copyWith(top: 5, bottom: 10),
      padding: const EdgeInsets.only(left: 16, top: 5, right: 10),
      decoration: BoxDecoration(color: const Color(0xFFF5F7F5), borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: widget.headerTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.instance.black06),
          ),
          const SizedBox(height: 5),
          if (widget.categories == null)
            SizedBox(
              height: AppSize.size.width * 0.3,
              child: const Center(child: CircularProgressIndicator()),
            )
          else if (widget.categories!.isEmpty)
            SizedBox(
              height: AppSize.size.width * 0.3,
              child: Center(
                child: AppText(
                  text: "No categories found",
                  style: TextStyle(color: AppColors.instance.black06),
                ),
              ),
            )
          else
            SizedBox(
              height: AppSize.size.width * 0.21,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.categories!.length,
                itemBuilder: (context, index) {
                  final category = widget.categories![index];
                  bool isSelected = selectedCategoryId == category.id;

                  return GestureDetector(
                    onTap: () {
                      selectCategory(category.id, name: category.name);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black.withValues(alpha: 0.08) : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AppImage(width: AppSize.size.width * 0.12, height: AppSize.size.width * 0.12, url: category.image),
                          ),
                          SizedBox(height: AppSize.size.width * 0.011),
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
