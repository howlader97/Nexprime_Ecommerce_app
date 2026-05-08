import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/screens/base_screen/terms_and_conditions_screen/provider/terms_and_conditions_screen_provider.dart';
import 'package:nexprime/screens/base_screen/widgets/base_data_widget.dart';
import 'package:nexprime/screens/base_screen/widgets/base_no_found_data_widget.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.white400,

      appBar: AppBar(
        leadingWidth: AppSize.size.width * 0.15,
        leading: InkWell(
          onTap: () {
            AppRoutes.instance.pop();
          },
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(
              vertical: AppSize.size.width * 0.02,
            ).copyWith(left: AppSize.size.width * 0.05),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.width(value: 5)),
              color: AppColors.instance.green,
            ),
            child: Icon(Icons.arrow_back, color: AppColors.instance.white50),
          ),
        ),
        centerTitle: true,
        title: AppText(
          text: "Terms & Conditions",
          fontSize: AppSize.size.width * 0.06,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          var provider = ref.watch(termsAndConditionsScreenProvider);
          return provider.when(
            data: (data) {
              if (data.isEmpty) {
                return BaseNoFoundDataWidget();
              }
              return BaseDataWidget(data: data);
            },
            error: (error, stackTrace) => BaseNoFoundDataWidget(),
            loading: () =>
                Skeletonizer(enabled: true, child: BaseNoFoundDataWidget()),
          );
        },
      ),
    );
  }
}
