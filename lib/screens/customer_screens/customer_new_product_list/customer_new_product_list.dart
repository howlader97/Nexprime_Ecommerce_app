import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nexprime/constant/app_locations.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/screens/customer_screens/customer_marketplace/provider/marketing_product_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_new_product_list/provider/publish_fee_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_new_product_list/widgets/custom_dropdown_Button.dart';
import 'package:nexprime/screens/customer_screens/customer_profile_screen/provider/customer_my_balance_provider.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/buttons/custom_app_bar.dart';
import 'package:nexprime/widgets/inputs/app_input_widget_tow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/provider/groceries_country_provider.dart';
import '../../../constant/app_colors.dart';
import '../../../models/marketing_product_model.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/image_userPick/image_user_pick.dart';
import 'package:nexprime/services/repository/marketing_product_repository.dart';
import 'package:nexprime/utils/app_snack_bar.dart';
import '../../../widgets/texts/app_text.dart';
import '../customer_my_product_screens/provider/my_marketing_product_provider.dart';

class CustomerNewProductList extends ConsumerStatefulWidget {
  final MarketingProductModel? product;
  const CustomerNewProductList({super.key, this.product});

  @override
  ConsumerState<CustomerNewProductList> createState() => _CustomerNewProductListState();
}

class _CustomerNewProductListState extends ConsumerState<CustomerNewProductList> {
  String? selectedType;
  late GlobalKey<FormState> formKey;
  late TextEditingController productName;
  late TextEditingController location;
  late TextEditingController description;
  late TextEditingController price;
  late TextEditingController shippingCharge;
  late TextEditingController taxFee;
  List<File> selectedImages = [];
  String shippingResponsibility = "CUSTOMER";
  bool isLoading = false;

  void onAppInitial() {
    try {
      formKey = GlobalKey<FormState>();
      productName = TextEditingController(text: widget.product?.name);
      location = TextEditingController(text: widget.product?.location);
      description = TextEditingController(text: widget.product?.description);
      price = TextEditingController(text: widget.product?.price?.toString());
      shippingCharge = TextEditingController(text: widget.product?.shippingCharge?.toString());
      taxFee = TextEditingController();

      if (widget.product != null) {
        selectedType = widget.product!.goodsType;
        shippingResponsibility = widget.product!.shippingResponsibility ?? "CUSTOMER";
      }
    } catch (e) {
      errorLog("Error is", e);
    }
  }

  @override
  void initState() {
    onAppInitial();
    super.initState();
  }

  void onAppClose() {
    try {
      productName.dispose();
      location.dispose();
      description.dispose();
      price.dispose();
      shippingCharge.dispose();
      taxFee.dispose();
    } catch (e) {
      errorLog("error is", e);
    }
  }

  @override
  void dispose() {
    onAppClose();
    super.dispose();
  }

  Future<void> onPublished() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      if (productName.text.isEmpty ||
          selectedType == null ||
          location.text.isEmpty ||
          description.text.isEmpty ||
          price.text.isEmpty ||
          (widget.product == null && selectedImages.isEmpty) ||
          shippingCharge.text.isEmpty ||
          taxFee.text.isEmpty) {
        AppSnackBar.instance.error("Please fill all fields and add at least one image");
        return;
      }

      double fee = 0;
      final feeAsync = ref.read(publishingFeeProvider);
      feeAsync.whenData((v) => fee = v);

      Map<String, dynamic> data = {
        "name": productName.text,
        "goodsType": selectedType,
        "location": location.text,
        "description": description.text,
        "price": price.text,
        "publishingFee": fee,
        "shippingResponsibility": shippingResponsibility,
        "shippingCharge": shippingCharge.text,
        "taxFee": num.tryParse(taxFee.text) ?? 0,
      };

      setState(() {
        isLoading = true;
      });

      String? paymentIntentId;

      // Handle Stripe live payment sheet if creating a new product and publishing fee > 0
      if (widget.product == null && fee > 0) {
        final intentData = await MarketingProductRepository.instance.createPublishingFeePaymentIntent();
        if (intentData == null || !intentData.containsKey('clientSecret')) {
          setState(() {
            isLoading = false;
          });
          AppSnackBar.instance.error("Failed to initialize publishing fee payment");
          return;
        }

        final clientSecret = intentData['clientSecret'].toString();
        if (clientSecret.isNotEmpty) {
          paymentIntentId = intentData['paymentIntentId']?.toString();

          try {
            await Stripe.instance.initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                merchantDisplayName: 'NexPrime',
                paymentIntentClientSecret: clientSecret,
                style: ThemeMode.light,
              ),
            );
            await Stripe.instance.presentPaymentSheet();
            data["stripePaymentIntentId"] = paymentIntentId;
          } on StripeException catch (e) {
            setState(() {
              isLoading = false;
            });
            debugPrint("STRIPE PUBLISH FEE ERROR: ${e.error.localizedMessage}");
            AppSnackBar.instance.error(e.error.localizedMessage ?? "Payment cancelled or failed");
            return;
          } catch (e) {
            setState(() {
              isLoading = false;
            });
            AppSnackBar.instance.error("Payment failed. Product was not published.");
            return;
          }
        }
      }

      bool success = false;
      if (widget.product != null) {
        success = await MarketingProductRepository.instance.updateMarketingProduct(widget.product!.id!, data, selectedImages);
      } else {
        success = await MarketingProductRepository.instance.publishMarketingProduct(data, selectedImages);
      }

      setState(() {
        isLoading = false;
      });

      if (success) {
        AppSnackBar.instance.success(widget.product != null ? "Product updated successfully" : "Product published successfully");
        ref.invalidate(myMarketingProductProvider);
        ref.invalidate(marketingProductProvider);
        ref.invalidate(customerMyBalanceProvider);
        AppRoutes.instance.pop();
      } else {
        AppSnackBar.instance.error(widget.product != null ? "Failed to update product" : "Failed to publish product", showTop: false);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      AppSnackBar.instance.error("An error occurred while processing the request");
    }
  }

  @override
  Widget build(BuildContext context) {
    final publishFeeAsync = ref.watch(publishingFeeProvider);
    final subcategories = ref.watch(groceriesProvider("Marketplace Management"));
    // List<String> typesOfGoods = [];
    // if (subcategories != null) {
    //   typesOfGoods = subcategories.map((c) => c.name).toList();
    //
    // }
    final typesOfGoods = subcategories?.map((c) => c.name).toList() ?? [];
    final safeValue = typesOfGoods.contains(selectedType) ? selectedType : null;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: CustomAppBar(
                  backButton: () {
                    AppRoutes.instance.pop();
                  },
                  title: widget.product != null ? "Edit Product" : "List New Product",
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.04, vertical: AppSize.size.width * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: widget.product != null ? "Update Product Entry" : "Create New Product Entry",
                        fontSize: 18,
                        color: AppColors.instance.black06,
                        fontWeight: FontWeight.w400,
                      ),
                      Gap(height: AppSize.size.width * 0.015),
                      Divider(color: AppColors.instance.grayEE),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    AppInputWidgetTwo(
                      title: "Name",
                      controller: productName,
                      hintText: "Product Name",
                      titleFontWeight: FontWeight.bold,
                      fillColor: AppColors.instance.transparent,
                    ),
                    CustomDropDownButton(
                      header: 'Types of Goods',
                      hintText: "Select Type",

                      value: safeValue,
                      items: typesOfGoods,
                      onChanged: (v) {
                        setState(() {
                          selectedType = v;
                        });
                      },
                    ),

                    // AppInputWidgetTwo(
                    //   title: "Location",
                    //   controller: location,
                    //   maxLines: 3,
                    //   titleFontWeight: FontWeight.bold,
                    //   hintText: "location",
                    //   fillColor: AppColors.instance.transparent,
                    // ),
                    CustomDropDownButton(
                      header: 'Location',
                      hintText: "Enter Location",

                      value: location.text.isNotEmpty ? location.text : null,
                      items: appLocations,
                      onChanged: (v) {
                        setState(() {
                          location.text = v ?? "";
                        });
                      },
                    ),

                    AppInputWidgetTwo(
                      title: "Description",
                      controller: description,
                      maxLines: 3,
                      titleFontWeight: FontWeight.bold,
                      hintText: "description...",
                      fillColor: AppColors.instance.transparent,
                    ),
                    AppInputWidgetTwo(
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                      title: "Price",
                      controller: price,
                      titleFontWeight: FontWeight.bold,
                      hintText: "¥00",
                      fillColor: AppColors.instance.transparent,
                    ),
                    AppInputWidgetTwo(
                      title: "Add Product photo & File",
                      hintText: "Add Image",
                      titleFontWeight: FontWeight.bold,
                      fillColor: AppColors.instance.transparent,
                      readOnly: true,
                      onTap: () {
                        appImageUserTake(
                          callBack: (v) {
                            setState(() {
                              selectedImages.add(File(v));
                            });
                          },
                        );
                      },
                      suffixIcon: GestureDetector(
                        onTap: () {
                          appImageUserTake(
                            callBack: (v) {
                              setState(() {
                                selectedImages.add(File(v));
                              });
                            },
                          );
                        },
                        child: Icon(Icons.attach_file),
                      ),
                      validator: (value) {
                        if (selectedImages.isEmpty && widget.product == null) {
                          return "Please add at least one image";
                        }
                        return null;
                      },
                    ),
                    if (selectedImages.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.046).copyWith(top: 10),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: selectedImages
                                .map(
                                  (file) => Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(file, width: 80, height: 80, fit: BoxFit.cover),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedImages.remove(file);
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                            child: Icon(Icons.close, size: 16, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.046, vertical: AppSize.size.width * 0.03).copyWith(bottom: 0),
                      child: Divider(color: AppColors.instance.grayEE),
                    ),

                    // publishFeeAsync.when(
                    //   data: (fee) {
                    //     return AppInputWidgetTwo(
                    //       isOptional: true,
                    //       readOnly: true,
                    //       inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                    //       needTopGap: false,
                    //       title: "Publishing fee",
                    //       titleFontWeight: FontWeight.bold,
                    //       titleColor: AppColors.instance.black06,
                    //       titleFontSize: AppSize.size.width * 0.044,
                    //       hintText: '$fee',
                    //       hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    //       fillColor: AppColors.instance.transparent,

                    //     );
                    //   },
                    //   error: (e, _) {
                    //     return Text("Error loading fee");
                    //   },
                    //   loading: () => Center(child: CircularProgressIndicator()),
                    // ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.046, vertical: AppSize.size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Shipping Cost Responsibility",
                        fontSize: AppSize.size.width * 0.052,
                        color: AppColors.instance.black06,
                        fontWeight: FontWeight.w600,
                      ),
                      Gap(height: AppSize.size.width * 0.015),
                      AppText(
                        text: "Who will pay the shipping fee?",
                        fontSize: AppSize.size.width * 0.042,
                        color: AppColors.instance.black06,
                        fontWeight: FontWeight.w400,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: shippingResponsibility == "CUSTOMER",
                            onChanged: (v) {
                              setState(() {
                                shippingResponsibility = "CUSTOMER";
                              });
                            },
                          ),
                          Gap(width: AppSize.size.width * 0.01),
                          AppText(text: "Buyer", fontSize: AppSize.size.width * 0.05, color: AppColors.instance.black06, fontWeight: FontWeight.w400),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: shippingResponsibility == "VENDOR",
                            onChanged: (v) {
                              setState(() {
                                shippingResponsibility = "VENDOR";
                              });
                            },
                          ),
                          Gap(width: AppSize.size.width * 0.01),
                          AppText(
                            text: "Seller",
                            fontSize: AppSize.size.width * 0.05,
                            color: AppColors.instance.black06,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: AppInputWidgetTwo(
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                  title: "Shipping Charge",
                  controller: shippingCharge,
                  titleFontWeight: FontWeight.bold,
                  titleColor: AppColors.instance.black06,
                  titleFontSize: AppSize.size.width * 0.044,
                  hintText: "¥ 0",
                  fillColor: AppColors.instance.transparent,
                ),
              ),
              SliverToBoxAdapter(
                child: AppInputWidgetTwo(
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  title: "Tax Fee *",
                  controller: taxFee,
                  titleFontWeight: FontWeight.bold,
                  titleColor: AppColors.instance.black06,
                  titleFontSize: AppSize.size.width * 0.044,
                  hintText: "¥ 0.00",
                  fillColor: AppColors.instance.transparent,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Tax Fee is required";
                    }
                    if (double.tryParse(value) == null) {
                      return "Please enter a valid number";
                    }
                    return null;
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: publishFeeAsync.when(
                  data: (fee) {
                    return Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSize.size.width * 0.046,
                            vertical: AppSize.size.width * 0.03,
                          ).copyWith(bottom: 0),
                          child: AppText(
                            text: "Publishing fee",
                            fontSize: AppSize.size.width * 0.044,
                            color: AppColors.instance.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSize.size.width * 0.046,
                            vertical: AppSize.size.width * 0.03,
                          ).copyWith(bottom: 0),
                          child: AppText(
                            text: '¥ $fee',
                            fontSize: AppSize.size.width * 0.044,
                            color: AppColors.instance.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  },
                  error: (e, _) {
                    return Text("Error loading fee");
                  },
                  loading: () => Center(child: CircularProgressIndicator()),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.046, vertical: AppSize.size.width * 0.046),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : AppButton(
                          height: AppSize.size.width * 0.12,
                          borderColor: AppColors.instance.green,
                          backgroundColor: AppColors.instance.green,
                          title: widget.product != null ? "Update" : "Publish",
                          onTap: onPublished,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
