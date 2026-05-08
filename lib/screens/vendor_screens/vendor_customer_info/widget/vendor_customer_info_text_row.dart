import 'package:flutter/material.dart';

import '../../../../utils/app_size.dart';
import '../../../../widgets/texts/app_text.dart';

class VendorCustomerInfoTextRow extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool titleBold;

  const VendorCustomerInfoTextRow({
    super.key,
    required this.title,
    required this.subTitle,
    this.titleBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.height(value: 6)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: title,
            fontSize: 16,
            fontWeight: titleBold ? FontWeight.w600 : FontWeight.w400,
            height: 1.5,
          ),
          Expanded(
            child: AppText(
              text: subTitle,
              fontSize: 16,
              fontWeight: titleBold ? FontWeight.w400 : FontWeight.w600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
