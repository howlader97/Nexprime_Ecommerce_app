import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_asserts_image_path.dart';
import 'package:nexprime/screens/customer_screens/customer_delivery_info/provider/delivery_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_profile_screen/provider/customer_profile_provider.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/inputs/app_input_widget_tow.dart';
import '../../../constant/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_size.dart';
import '../../../utils/gap.dart';
import '../../../widgets/buttons/icon_button_widget.dart';
import '../../../widgets/texts/app_text.dart';

class CustomerDeliveryInfo extends ConsumerStatefulWidget {
  const CustomerDeliveryInfo({super.key});

  @override
  ConsumerState<CustomerDeliveryInfo> createState() => _CustomerDeliveryInfoState();
}

class _CustomerDeliveryInfoState extends ConsumerState<CustomerDeliveryInfo> {
  TextEditingController nameTEController = TextEditingController();
  TextEditingController postTEController = TextEditingController();
  TextEditingController addressTEController = TextEditingController();
  TextEditingController roomNumberTEController = TextEditingController();
  TextEditingController phoneTEController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // পেমেন্ট পদ্ধতি: "ONLINE" অথবা "COD"
  String _selectedPaymentMethod = "ONLINE";

  void onAppInitial() {
    try {
      _formKey = GlobalKey<FormState>();
      nameTEController = TextEditingController();
      postTEController = TextEditingController();
      addressTEController = TextEditingController();
      roomNumberTEController = TextEditingController();
      phoneTEController = TextEditingController();

      var customer = ref.read(customerProfileProvider).value;
      if (customer == null) {
        return;
      }
      nameTEController.text = customer.fullname;

      phoneTEController.text = customer.phonenumber;
    } catch (e) {
      errorLog("CustomerDeliveryInfo onAppInitial error:", e);
    }
  }

  @override
  void initState() {
    super.initState();
    onAppInitial();
  }

  @override
  void dispose() {
    nameTEController.dispose();
    postTEController.dispose();
    addressTEController.dispose();
    roomNumberTEController.dispose();
    phoneTEController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deliveryData = ref.watch(deliveryProvider);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  IconButtonWidget(
                    onTap: () {
                      AppRoutes.instance.pop();
                    },
                    icon: Icons.arrow_back,
                  ),
                  Gap(width: AppSize.size.width * 0.03),
                  AppText(
                    text: "1.Delivery Info",
                    fontSize: AppSize.size.width * 0.055,
                    color: AppColors.instance.black06,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  ClipRRect(
                    child: AppImage(height: AppSize.size.height * 0.12, isZomBle: true, path: AppAssertsImagePath.instance.logoImage),
                  ),
                  AppText(text: "Shipping Setup", fontWeight: FontWeight.w600, fontSize: AppSize.size.width * 0.05),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  AppInputWidgetTwo(
                    controller: nameTEController,
                    contentPadding: EdgeInsets.symmetric(vertical: AppSize.width(value: 5), horizontal: AppSize.width(value: 10)),
                    title: 'Full Name',
                    titleColor: AppColors.instance.black06,
                    titleFontSize: AppSize.size.width * 0.048,
                    hintText: "Enter full Name",
                    fillColor: AppColors.instance.white50,
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter name";
                      }
                      return null;
                    },
                  ),
                  AppInputWidgetTwo(
                    controller: postTEController,
                    contentPadding: EdgeInsets.symmetric(vertical: AppSize.width(value: 5), horizontal: AppSize.width(value: 10)),
                    title: 'Post Code',
                    hintText: "Enter post code",
                    titleColor: AppColors.instance.black06,
                    titleFontSize: AppSize.size.width * 0.048,
                    fillColor: AppColors.instance.white50,
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter post Code";
                      }
                      return null;
                    },
                  ),
                  AppInputWidgetTwo(
                    controller: addressTEController,
                    contentPadding: EdgeInsets.symmetric(vertical: AppSize.width(value: 5), horizontal: AppSize.width(value: 10)),
                    title: 'Full Address',
                    titleColor: AppColors.instance.black06,
                    titleFontSize: AppSize.size.width * 0.048,
                    hintText: "Enter address",
                    fillColor: AppColors.instance.white50,
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter address";
                      }
                      return null;
                    },
                  ),
                  AppInputWidgetTwo(
                    controller: roomNumberTEController,
                    contentPadding: EdgeInsets.symmetric(vertical: AppSize.width(value: 5), horizontal: AppSize.width(value: 10)),
                    title: 'Building name/Room number',
                    titleColor: AppColors.instance.black06,
                    titleFontSize: AppSize.size.width * 0.048,
                    hintText: "Enter house address",
                    fillColor: AppColors.instance.white50,
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter room information";
                      }
                      return null;
                    },
                  ),
                  AppInputWidgetTwo(
                    keyboardType: TextInputType.number,
                    controller: phoneTEController,
                    contentPadding: EdgeInsets.symmetric(vertical: AppSize.width(value: 5), horizontal: AppSize.width(value: 10)),
                    title: 'Phone number',
                    titleColor: AppColors.instance.black06,
                    titleFontSize: AppSize.size.width * 0.048,
                    hintText: "Enter Number",
                    fillColor: AppColors.instance.white50,
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter phone";
                      }
                      return null;
                    },
                  ),

                  // ─── পেমেন্ট পদ্ধতি সিলেকশন ───
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.size.width * 0.048,
                      vertical: AppSize.size.height * 0.015,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: "Payment Method",
                          fontSize: AppSize.size.width * 0.048,
                          color: AppColors.instance.black06,
                          fontWeight: FontWeight.w600,
                        ),
                        Gap(height: AppSize.size.height * 0.01),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedPaymentMethod = "ONLINE";
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: _selectedPaymentMethod == "ONLINE"
                                        ? AppColors.instance.green.withValues(alpha: 0.12)
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _selectedPaymentMethod == "ONLINE"
                                          ? AppColors.instance.green
                                          : Colors.grey.shade300,
                                      width: _selectedPaymentMethod == "ONLINE" ? 2 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.credit_card_rounded,
                                        color: _selectedPaymentMethod == "ONLINE"
                                            ? AppColors.instance.green
                                            : Colors.grey,
                                        size: 30,
                                      ),
                                      const SizedBox(height: 6),
                                      AppText(
                                        text: "Online Payment",
                                        fontSize: AppSize.size.width * 0.035,
                                        color: _selectedPaymentMethod == "ONLINE"
                                            ? AppColors.instance.green
                                            : Colors.grey.shade600,
                                        fontWeight: _selectedPaymentMethod == "ONLINE"
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Gap(width: AppSize.size.width * 0.03),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedPaymentMethod = "COD";
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: _selectedPaymentMethod == "COD"
                                        ? Colors.orange.withValues(alpha: 0.12)
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _selectedPaymentMethod == "COD"
                                          ? Colors.orange
                                          : Colors.grey.shade300,
                                      width: _selectedPaymentMethod == "COD" ? 2 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.money_rounded,
                                        color: _selectedPaymentMethod == "COD"
                                            ? Colors.orange
                                            : Colors.grey,
                                        size: 30,
                                      ),
                                      const SizedBox(height: 6),
                                      AppText(
                                        text: "Cash on Delivery",
                                        fontSize: AppSize.size.width * 0.035,
                                        color: _selectedPaymentMethod == "COD"
                                            ? Colors.orange
                                            : Colors.grey.shade600,
                                        fontWeight: _selectedPaymentMethod == "COD"
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_selectedPaymentMethod == "COD") ...[
                          Gap(height: AppSize.size.height * 0.008),
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.orange, size: 16),
                              const SizedBox(width: 6),
                              Expanded(
                                child: AppText(
                                  text: "No extra charge for Cash on Delivery. Pay when you receive.",
                                  fontSize: AppSize.size.width * 0.032,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.048, vertical: AppSize.size.height * 0.02),
                    child: AppButton(
                      isLoading: deliveryData.isLoading,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          ref
                              .read(deliveryProvider.notifier)
                              .getDeliveryData(
                                name: nameTEController.text.trim(),
                                postCode: postTEController.text.trim(),
                                address: addressTEController.text.trim(),
                                roomNumber: roomNumberTEController.text.trim(),
                                phoneNumber: phoneTEController.text.trim(),
                                paymentMethod: _selectedPaymentMethod,
                              );
                        }
                      },

                      height: AppSize.size.height * 0.05,
                      backgroundColor: _selectedPaymentMethod == "COD"
                          ? Colors.orange
                          : AppColors.instance.green,
                      borderColor: _selectedPaymentMethod == "COD"
                          ? Colors.orange
                          : AppColors.instance.green,
                      title: _selectedPaymentMethod == "COD"
                          ? "Place COD Order"
                          : "Next Step",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
