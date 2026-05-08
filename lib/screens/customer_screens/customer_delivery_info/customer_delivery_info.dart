import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_asserts_image_path.dart';
import 'package:nexprime/screens/customer_screens/customer_delivery_info/provider/delivery_provider.dart';
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
   late TextEditingController nameTEController =TextEditingController();
   final TextEditingController postTEController=TextEditingController();
   final TextEditingController addressTEController=TextEditingController();
   final TextEditingController roomNumberTEController=TextEditingController();
   final TextEditingController phoneTEController=TextEditingController();
   final GlobalKey<FormState> _formKey=GlobalKey<FormState>();


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
     final deliveryData=ref.watch(deliveryProvider);
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
                    child: AppImage(
                      height: AppSize.size.height * 0.12,
                      isZomBle: true,
                      path: AppAssertsImagePath.instance.logoImage,
                    ),
                  ),
                  AppText(
                    text: "Shipping Setup",
                    fontWeight: FontWeight.w600,
                    fontSize: AppSize.size.width * 0.05,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  AppInputWidgetTwo(
                    controller: nameTEController,
                    contentPadding: EdgeInsets.symmetric(vertical: AppSize.width(value: 5),horizontal: AppSize.width(value: 10)),
                    title: 'Full Name',
                    titleColor: AppColors.instance.black06,
                    titleFontSize: AppSize.size.width * 0.048,
                    hintText: "Enter full Name",
                    fillColor: AppColors.instance.white50,
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return "Enter name";
                      }
                      return null;
                    },
                  ),
                  AppInputWidgetTwo(
                    controller: postTEController,
                    contentPadding: EdgeInsets.symmetric(vertical: AppSize.width(value: 5),horizontal: AppSize.width(value: 10)),
                    title: 'Post Code',
                    hintText: "Enter post code",
                    titleColor: AppColors.instance.black06,
                    titleFontSize: AppSize.size.width * 0.048,
                    fillColor: AppColors.instance.white50,
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return "Enter post Code";
                      }
                      return null;
                    },
                  ),
                  AppInputWidgetTwo(
                    controller: addressTEController,
                    contentPadding: EdgeInsets.symmetric(vertical: AppSize.width(value: 5),horizontal: AppSize.width(value: 10)),
                    title: 'Full Address',
                    titleColor: AppColors.instance.black06,
                    titleFontSize: AppSize.size.width * 0.048,
                    hintText: "Enter address",
                    fillColor: AppColors.instance.white50,
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return "Enter address";
                      }
                      return null;
                    },
                  ),
                  AppInputWidgetTwo(
                    controller: roomNumberTEController,
                    contentPadding: EdgeInsets.symmetric(vertical: AppSize.width(value: 5),horizontal: AppSize.width(value: 10)),
                    title: 'Building name/Room number',
                    titleColor: AppColors.instance.black06,
                    titleFontSize: AppSize.size.width * 0.048,
                    hintText: "Enter house address",
                    fillColor: AppColors.instance.white50,
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return "Enter room information";
                      }
                      return null;
                    },
                  ),
                  AppInputWidgetTwo(
                    keyboardType: TextInputType.number,
                    controller: phoneTEController,
                    contentPadding: EdgeInsets.symmetric(vertical: AppSize.width(value: 5),horizontal: AppSize.width(value: 10)),
                    title: 'Phone number',
                    titleColor: AppColors.instance.black06,
                    titleFontSize: AppSize.size.width * 0.048,
                    hintText: "Enter Number",
                    fillColor: AppColors.instance.white50,
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return "Enter phone";
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.size.width * 0.048,
                      vertical: AppSize.size.height * 0.02,
                    ),
                    child: AppButton(
                      isLoading: deliveryData.isLoading,
                      onTap: () {
                        if(_formKey.currentState!.validate()){
                          ref.read(deliveryProvider.notifier).getDeliveryData(
                              name: nameTEController.text.trim(),
                              postCode: postTEController.text.trim(),
                              address: addressTEController.text.trim(),
                              roomNumber: roomNumberTEController.text.trim(),
                              phoneNumber: phoneTEController.text.trim());
                        }
                      },

                      height: AppSize.size.height * 0.05,
                      backgroundColor: AppColors.instance.green,
                      borderColor: AppColors.instance.green,
                      title: "Next Step",
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
