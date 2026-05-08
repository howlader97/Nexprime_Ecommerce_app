import 'package:flutter/material.dart';

import '../../../../utils/app_size.dart';
import '../../../../widgets/texts/app_text.dart';

class VendorOrderSuccessTop extends StatelessWidget {
  const VendorOrderSuccessTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSize.height(value: 16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppText(
                text: "25/01/26",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
              OutlinedButton(onPressed: () {}, child: const Text("Shipped")),
            ],
          ),
          const AppText(
            text: "#ORD-1001",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ],
      ),
    );
  }
}