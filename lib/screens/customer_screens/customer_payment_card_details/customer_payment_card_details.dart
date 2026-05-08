import 'package:flutter/material.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/inputs/app_input_widget_tow.dart';

import '../../../constant/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_size.dart';
import '../../../utils/gap.dart';
import '../../../widgets/buttons/icon_button_widget.dart';
import '../../../widgets/texts/app_text.dart';

class CustomerPaymentCardDetails extends StatelessWidget {
  const CustomerPaymentCardDetails({super.key});

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
                  AppInputWidgetTwo(
                    contentPadding: EdgeInsets.symmetric(vertical: AppSize.width(value: 5),horizontal: AppSize.width(value: 10)),
                    title: "Card holder name",
                    hintText: "Ales",
                    titleFontSize: AppSize.size.width * 0.05,
                    fillColor: AppColors.instance.white50,
                  ),
                  AppInputWidgetTwo(
                    contentPadding: EdgeInsets.symmetric(vertical: AppSize.width(value: 5),horizontal: AppSize.width(value: 10)),
                    title: "Card Number",
                    hintText: "54675675678",
                    titleFontSize: AppSize.size.width * 0.05,
                    fillColor: AppColors.instance.white50,
                  ),
                  AppInputWidgetTwo(
                    contentPadding: EdgeInsets.symmetric(vertical: AppSize.width(value: 5),horizontal: AppSize.width(value: 10)),
                    title: "Expiry Date",
                    hintText: "12/13",
                    titleFontSize: AppSize.size.width * 0.05,
                    fillColor: AppColors.instance.white50,
                  ),
                  AppInputWidgetTwo(
                    contentPadding: EdgeInsets.symmetric(vertical: AppSize.width(value: 5),horizontal: AppSize.width(value: 10)),
                    title: "CVV",
                    hintText: "123",
                    titleFontSize: AppSize.size.width * 0.05,
                    fillColor: AppColors.instance.white50,
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.044,vertical: AppSize.size.height * 0.022),
                    child: AppButton(
                      height: AppSize.size.height * 0.05,
                      backgroundColor: AppColors.instance.green,
                      borderColor: AppColors.instance.green,
                      title: "Next Step",
                    ),
                  )
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
