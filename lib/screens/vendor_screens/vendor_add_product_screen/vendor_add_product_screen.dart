import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/screens/vendor_screens/vendor_add_product_screen/provider/vendor_add_product_screen_provider.dart';
import 'package:nexprime/screens/vendor_screens/vendor_add_product_screen/provider/vendor_add_product_screen_provider_state.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/buttons/icon_button_widget.dart';
import 'package:nexprime/widgets/inputs/app_input_widget_tow.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/provider/groceries_country_provider.dart';
import '../../../constant/app_colors.dart';
import '../../../models/groceries_country_model.dart';
import '../../../utils/app_snack_bar.dart';
import '../../../widgets/image_userPick/image_user_pick.dart';
import '../../../widgets/buttons/flutter_switch.dart';
import '../../customer_screens/customer_new_product_list/widgets/custom_dropdown_Button.dart';
import 'package:nexprime/models/product_model.dart';

import '../vendor_common_widget/vendor_custom_text_title16.dart';
import '../vendor_profile_screen/provider/vendor_profile_provider.dart';

class VendorAddProductScreen extends ConsumerStatefulWidget {
  final ProductModel? product;
  const VendorAddProductScreen({super.key, this.product});

  @override
  ConsumerState<VendorAddProductScreen> createState() =>
      _VendorAddProductScreenState();
}

class _VendorAddProductScreenState
    extends ConsumerState<VendorAddProductScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController basePriceController;
  late TextEditingController stockUnitsController;
  late TextEditingController sizeController;
  late TextEditingController colorsController;
  late TextEditingController salePriceController;
  late TextEditingController shippingChargeController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    basePriceController = TextEditingController();
    stockUnitsController = TextEditingController();
    sizeController = TextEditingController();
    colorsController = TextEditingController();
    salePriceController = TextEditingController();
    shippingChargeController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    basePriceController.dispose();
    stockUnitsController.dispose();
    sizeController.dispose();
    colorsController.dispose();
    salePriceController.dispose();
    shippingChargeController.dispose();
    super.dispose();
  }

  void onPublished() async {
    final provider = ref.read(vendorAddProductScreenProvider);

    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        basePriceController.text.isEmpty ||
        stockUnitsController.text.isEmpty ||
        provider.selectedFoodTypeId == null ||
        provider.selectedCategoryId == null ||
        provider.images.isEmpty ||
        shippingChargeController.text.isEmpty) {
      AppSnackBar.instance.error(
        "Please fill all mandatory fields and add at least one image",
      );
      return;
    }

    if (provider.isDiscountSale && salePriceController.text.isEmpty) {
      AppSnackBar.instance.error(
        "Please provide a sale price for discounted items",
      );
      return;
    }

    Map<String, dynamic> data = {
      "name": nameController.text,
      "description": descriptionController.text,
      "basePrice": basePriceController.text,
      "stockUnits": stockUnitsController.text,
      "isDiscountSale": provider.isDiscountSale,
      "shippingResponsibility": provider.shippingResponsibility,
      "shippingCharge": shippingChargeController.text,
      "category_ids":
          "${provider.selectedFoodTypeId},${provider.selectedCategoryId}",
    };

    if (provider.isDiscountSale) {
      data["salePrice"] = salePriceController.text;
    }

    if (!provider.isGrocery) {
      data["size"] = sizeController.text;
      data["colors"] = colorsController.text;
    }

    bool success = await ref
        .read(vendorAddProductScreenProvider.notifier)
        .publishProduct(data);

    if (success) {
      AppSnackBar.instance.success("Product published successfully");
      nameController.clear();
      descriptionController.clear();
      basePriceController.clear();
      stockUnitsController.clear();
      sizeController.clear();
      colorsController.clear();
      salePriceController.clear();
      shippingChargeController.clear();
      ref.read(vendorAddProductScreenProvider.notifier).resetState();
      ref.read(vendorStoreProvider.notifier).fetchVendorStoreData();
      AppRoutes.instance.pop();
    } else {
      AppSnackBar.instance.error("Failed to publish product");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(vendorAddProductScreenProvider);

    return Scaffold(
      body: SafeArea(
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: .symmetric(
                        vertical: AppSize.size.height * 0.02,
                        horizontal: AppSize.size.width * 0.03,
                      ),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Row(children: [IconButtonWidget(onTap: (){
                            AppRoutes.instance.pop();
                          }, icon: Icons.arrow_back),
                            Gap(width: 10,),
                            AppText(text: "Create New Catalog Entry",fontSize: 22,fontWeight: FontWeight.w600,)],),

                          const Gap(height: 12),
                          const Divider(),

                          VendorCustomTextTitle16(title: "Catalog type"),
                          const Gap(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: provider.isGrocery
                                    ? ElevatedButton(
                                        onPressed: () => ref
                                            .read(
                                              vendorAddProductScreenProvider
                                                  .notifier,
                                            )
                                            .toggleCatalogType(true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.instance.green,
                                        ),
                                        child: const AppText( text: 
                                          "Grocery",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : OutlinedButton(
                                        onPressed: () => ref
                                            .read(
                                              vendorAddProductScreenProvider
                                                  .notifier,
                                            )
                                            .toggleCatalogType(true),
                                        child: const AppText( text: "Grocery"),
                                      ),
                              ),
                              const Gap(width: 4),
                              Expanded(
                                child: !provider.isGrocery
                                    ? ElevatedButton(
                                        onPressed: () => ref
                                            .read(
                                              vendorAddProductScreenProvider
                                                  .notifier,
                                            )
                                            .toggleCatalogType(false),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.instance.green,
                                        ),
                                        child: const AppText( text: 
                                          "Wardrobe",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : OutlinedButton(
                                        onPressed: () => ref
                                            .read(
                                              vendorAddProductScreenProvider
                                                  .notifier,
                                            )
                                            .toggleCatalogType(false),
                                        child: const AppText( text: "Wardrobe"),
                                      ),
                              ),
                            ],
                          ),
                          const Gap(height: 12),

                          AppInputWidgetTwo(
                            controller: nameController,
                            padding: EdgeInsets.zero,
                            title: "Name *",
                            hintText: "Product Name",
                          ),
                          const Gap(height: 12),

                          // Dropdowns
                          _buildFoodTypeDropdown(provider),
                          const Gap(height: 12),
                          _buildCategoryDropdown(provider),
                          const Gap(height: 12),

                          AppInputWidgetTwo(
                            controller: descriptionController,
                            padding: .zero,
                            title: "Description *",
                            hintText: "Write About Product",
                            minLines: 3,
                          ),
                          const Gap(height: 12),

                          // Images
                          VendorCustomTextTitle16(title: "Product Photos *"),
                          const Gap(height: 8),
                          _buildImageSelection(provider),
                          const Gap(height: 12),

                          // Price & Inventory
                          AppText(
                            text: "Price & Inventory",
                            fontSize: 16,
                            fontWeight: .bold,
                          ),
                          const Divider(),
                          AppInputWidgetTwo(
                            controller: basePriceController,
                            padding: .zero,
                            title: "Base price *",
                            hintText: "\$0.00",
                          ),
                          const Gap(height: 12),
                          AppInputWidgetTwo(
                            controller: stockUnitsController,
                            padding: .zero,
                            title: "Stock units *",
                            hintText: "0",
                          ),
                          const Gap(height: 12),

                          // Conditionally show Size and Colors for Wardrobe
                          if (!provider.isGrocery) ...[
                            AppInputWidgetTwo(
                              controller: sizeController,
                              padding: .zero,
                              title: "Size (comma separated, e.g. l,m,s)",
                              hintText: "S,M,L",
                            ),
                            const Gap(height: 12),
                            AppInputWidgetTwo(
                              controller: colorsController,
                              padding: .zero,
                              title: "Colors (e.g. Red,Blue)",
                              hintText: "Red",
                            ),
                            const Gap(height: 12),
                          ],

                          // Sale Settings
                          _buildSaleSettings(provider),
                          const Gap(height: 12),

                          // Shipping
                          _buildShippingSection(provider),
                          const Gap(height: 24),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: onPublished,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.instance.green,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: const AppText( text: 
                                "Published",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const Gap(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFoodTypeDropdown(VendorAddProductScreenProviderState state) {
    final listAsync = ref.watch(
      groceriesProvider(
        state.isGrocery ? "Grocery Country" : "Wardrobe Country",
      ),
    );
    List<GroceriesCountryModel> items = listAsync ?? [];

    return CustomDropDownButton(
      padding: EdgeInsets.all(0),
      header: state.isGrocery ? "Food Type / Cuisine *" : "Style / Type *",
      items: items.map((e) => e.name).toList(),
      hintText: "Select Type",
      value: state.foodType.isEmpty ? null : state.foodType,
      onChanged: (val) {
        final selected = items.firstWhere((e) => e.name == val);
        ref
            .read(vendorAddProductScreenProvider.notifier)
            .changeFoodTypeDropdown(val, selected.id);
      },
    );
  }

  Widget _buildCategoryDropdown(VendorAddProductScreenProviderState state) {
    final listAsync = ref.watch(
      groceriesProvider(state.isGrocery ? "Grocery" : "Wardrobe"),
    );
    List<GroceriesCountryModel> items = listAsync ?? [];

    return CustomDropDownButton(
      header: "Category *",
      padding: EdgeInsets.all(0),
      items: items.map((e) => e.name).toList(),
      hintText: "Select Category",
      value: state.category.isEmpty ? null : state.category,
      onChanged: (val) {
        final selected = items.firstWhere((e) => e.name == val);
        ref
            .read(vendorAddProductScreenProvider.notifier)
            .changeDropdown(val, selected.id);
      },
    );
  }

  Widget _buildImageSelection(VendorAddProductScreenProviderState state) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            appImageUserTake(
              callBack: (v) {
                ref
                    .read(vendorAddProductScreenProvider.notifier)
                    .addImage(File(v));
              },
            );
          },
          child: Container(
            width: .infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
                style: .solid,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.add_a_photo,
                  color: AppColors.instance.green,
                  size: 32,
                ),
                const Gap(height: 8),
                const AppText( text: 
                  "Add Product Photos",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        if (state.images.isNotEmpty) ...[
          const Gap(height: 12),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: .horizontal,
              itemCount: state.images.length,
              itemBuilder: (context, index) {
                final file = state.images[index];
                return Stack(
                  children: [
                    Padding(
                      padding: const .only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          file,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => ref
                            .read(vendorAddProductScreenProvider.notifier)
                            .removeImage(file),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSaleSettings(VendorAddProductScreenProviderState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText( text: 
                  "Sale Settings",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                AppText( text: 
                  "Apply a 'Sale' badge",
                  style: TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.bold),
                ),
              ],
            ),
            FlutterSwitch(
              value: state.isDiscountSale,
              onToggle: (val) => ref
                  .read(vendorAddProductScreenProvider.notifier)
                  .toggleDiscountSale(val),
              height: 25,
              width: 45,
            ),
          ],
        ),
        if (state.isDiscountSale) ...[
          const Gap(height: 12),
          AppInputWidgetTwo(
            controller: salePriceController,
            padding: .zero,
            title: "Sale Price *",
            hintText: "\$0.00",
          ),
        ],
      ],
    );
  }

  Widget _buildShippingSection(VendorAddProductScreenProviderState state) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const AppText( text: 
          "Shipping Cost Responsibility",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const AppText( text: 
          "Who will pay the shipping fee?",
          style: TextStyle(fontSize: 12, color: Colors.black),
        ),
        const Gap(height: 8),
        Row(
          children: [
            Radio<String>(
              value: "CUSTOMER",
              groupValue: state.shippingResponsibility,
              onChanged: (v) => ref
                  .read(vendorAddProductScreenProvider.notifier)
                  .changeShippingResponsibility(v!),
              activeColor: AppColors.instance.green,
            ),
            AppText( text: 
              "Customer",
              style: TextStyle(color: AppColors.instance.black06),
            ),
            const Gap(width: 16),
            Radio<String>(
              value: "VENDOR",
              groupValue: state.shippingResponsibility,
              onChanged: (v) => ref
                  .read(vendorAddProductScreenProvider.notifier)
                  .changeShippingResponsibility(v!),
              activeColor: AppColors.instance.green,
            ),
            AppText( text:  "Vendor", style: TextStyle(color: AppColors.instance.black06)),
          ],
        ),
        const Gap(height: 12),
        AppInputWidgetTwo(
          controller: shippingChargeController,
          padding: EdgeInsets.zero,
          title: "Shipping Charge *",
          hintText: "\$0.00",
        ),
      ],
    );
  }
}
