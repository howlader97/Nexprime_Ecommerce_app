import 'package:flutter/material.dart';

import '../../../../constant/app_colors.dart';
import '../../../../utils/app_size.dart';
import '../../../../widgets/texts/app_text.dart';

class WidgetRow extends StatelessWidget {
  final String name;
  final String value;
  const WidgetRow({
    super.key, required this.name, required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(text: name,
          fontSize: AppSize.size.width * 0.048,
          color: AppColors.instance.black06,
          fontWeight: FontWeight.w400,),
        AppText(text: value,
          fontSize: AppSize.size.width * 0.046,
          color: AppColors.instance.black06,
          fontWeight: FontWeight.w600,),
      ],
    );
  }
}