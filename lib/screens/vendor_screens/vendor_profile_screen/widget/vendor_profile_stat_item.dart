import 'package:flutter/material.dart';

import '../../../../widgets/texts/app_text.dart';

class VendorProfileStatItem extends StatelessWidget {
  const VendorProfileStatItem({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(text: value, fontWeight: FontWeight.w600),
        AppText(text: label, fontSize: 12),
      ],
    );
  }
}
