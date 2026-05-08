import 'package:flutter/material.dart';

import '../../../widgets/texts/app_text.dart';

class VendorCustomTextTitle16 extends StatelessWidget {
  final String title;
  const VendorCustomTextTitle16({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: title,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.5,
    );
  }
}
