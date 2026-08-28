import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/provider/stores_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_groceries_home_categories/provider/product_provider.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import '../../../../constant/app_colors.dart';
import '../../../../utils/app_size.dart';

class ShopsSectionWidget extends ConsumerStatefulWidget {
  final int countryId;
  const ShopsSectionWidget({super.key, required this.countryId});

  @override
  ConsumerState<ShopsSectionWidget> createState() => _ShopsSectionWidgetState();
}

class _ShopsSectionWidgetState extends ConsumerState<ShopsSectionWidget> {
  int? selectedShopId;

  void selectShop(int id) {
    if (selectedShopId == id) {
      setState(() {
        selectedShopId = null;
      });
      ref.read(productProvider(widget.countryId).notifier).getProduct();
    } else {
      setState(() {
        selectedShopId = id;
      });
      ref.read(productProvider(widget.countryId).notifier).getProduct(shopId: id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stores = ref.watch(storesProvider);
    if (stores == null) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (stores.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).copyWith(top: 0),
      padding: const EdgeInsets.only(left: 16, top: 5, right: 10),
      decoration: BoxDecoration(color: AppColors.instance.grayEE, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(text: "Shops", fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.instance.black06, height: 1.5),

          SizedBox(
            height: AppSize.size.width * 0.2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  final store = stores[index];
                  bool isSelected = selectedShopId == store.id;

                  return GestureDetector(
                    onTap: () {
                      selectShop(store.id);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black.withValues(alpha: 0.08) : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: AppSize.width(value: 40),
                            height: AppSize.width(value: 40),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.instance.purple500, width: 1.5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: store.photo != null
                                  ? AppImage(url: store.photo!, width: AppSize.width(value: 40), height: AppSize.width(value: 50), fit: BoxFit.cover)
                                  : Icon(Icons.shopping_cart_outlined, color: AppColors.instance.purple500, size: 24),
                            ),
                          ),

                          SizedBox(
                            width: AppSize.width(value: 70),
                            child: Text(
                              store.name,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: AppSize.size.width * 0.035, color: AppColors.instance.black06, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
