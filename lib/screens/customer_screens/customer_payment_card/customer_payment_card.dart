import 'package:flutter/material.dart';
import '../../../constant/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_size.dart';
import '../../../utils/gap.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/buttons/icon_button_widget.dart';
import '../../../widgets/texts/app_text.dart';

class CustomerPaymentCard extends StatefulWidget {
  const CustomerPaymentCard({super.key});

  @override
  State<CustomerPaymentCard> createState() => _CustomerPaymentCardState();
}

class _CustomerPaymentCardState extends State<CustomerPaymentCard> {
  String selectedMethod = "Debit/credit";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
              title: Row(
                children: [
                  IconButtonWidget(
                    onTap: () {
                      AppRoutes.instance.pop();
                    },
                    icon: Icons.arrow_back,
                  ),
                  Gap(width: AppSize.size.width * 0.04),
                  AppText(
                    text: "2. Payment Method",
                    fontSize: AppSize.size.width * 0.065,
                    color: AppColors.instance.black06,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.045,
                  vertical: AppSize.size.height * 0.02,
                ),
                child: Column(
                  children: [
                    buildPaymentOption(
                      "Cash on Delivery",
                      "https://cdn-icons-png.flaticon.com/512/10149/10149313.png",
                    ),
                    Gap(height: AppSize.size.height * 0.02),
                    buildPaymentOption(
                      "Debit/credit",
                      "https://cdn-icons-png.flaticon.com/512/6963/6963703.png",
                    ),
                    Gap(height: AppSize.size.height * 0.02),
                    buildPaymentOption(
                      "Pay Pay",
                      "https://cdn-icons-png.flaticon.com/512/174/174861.png",
                    ),
                    Gap(height: AppSize.size.height * 0.02),
                    buildPaymentOption(
                      "Apple Pay",
                      "https://cdn-icons-png.flaticon.com/512/16183/16183570.png",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentOption(String title, String iconUrl) {
    bool isSelected = selectedMethod == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = title;
        });
      },
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.instance.grayEE,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding:  EdgeInsets.all(AppSize.size.width * 0.032),
              child: AppImage(
                url: iconUrl ,
                height: AppSize.size.height * 0.035,
                width: AppSize.size.height * 0.035,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Gap(width: AppSize.size.width * 0.04),
          Expanded(
            child: AppText(
              text: title,
              fontSize: AppSize.size.width * 0.045,
              color: AppColors.instance.black06,
              fontWeight: FontWeight.w600,
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AppColors.instance.blue
                    : AppColors.instance.black06,
                width: 1.5,
              ),
              color: isSelected ? AppColors.instance.accentBlue : Colors.transparent,
            ),
            child: SizedBox(
              height: AppSize.size.height * 0.025,
              width: AppSize.size.height * 0.025,
            ),
          ),
        ],
      ),
    );
  }
}
