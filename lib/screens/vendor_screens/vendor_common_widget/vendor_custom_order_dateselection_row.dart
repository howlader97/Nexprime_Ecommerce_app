import 'package:flutter/material.dart';

import '../../../widgets/texts/app_text.dart';

/// ------------------- DATE SELECTION ROW -------------------
class VendorCustomOrderDateselectionRow extends StatelessWidget {
  const VendorCustomOrderDateselectionRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AppText(text: "January 20"),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(text: "January"),
                SizedBox(width: 6),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
