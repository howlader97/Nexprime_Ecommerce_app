import 'package:flutter/material.dart';
import 'package:nexprime/screens/vendor_screens/vendor_order_success/vendor_order_success.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../../../utils/gap.dart';

class VendorCustomerOrderActionButton extends StatelessWidget {
  const VendorCustomerOrderActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: const AppText( text: "Mark as full filled"),
          ),
        ),
        const Gap(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VendorOrderSuccess()),
              );
            },
            child: const AppText( text: "Add Track"),
          ),
        ),
      ],
    );
  }
}
