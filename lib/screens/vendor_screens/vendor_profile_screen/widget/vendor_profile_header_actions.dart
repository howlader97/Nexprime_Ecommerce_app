import 'package:flutter/material.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../../../routes/app_routes.dart';

class VendorProfileHeaderActions extends StatelessWidget {
  final Function() onPressed;

  const VendorProfileHeaderActions({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            AppRoutes.instance.pushNamed(
              AppRoutesKey.instance.vendorEditProfileScreen,
            );
          },
          icon: const Icon(Icons.edit, size: 16),
          label: const AppText( text: 
            "Edit",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
