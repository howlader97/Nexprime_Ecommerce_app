import 'package:flutter/material.dart';
import 'package:nexprime/screens/vendor_screens/vendor_live_screen/widget/vendor_live_blur_container.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

class VendorLiveViewOfferButton extends StatelessWidget {
  const VendorLiveViewOfferButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 10),
      child: GestureDetector(
        onTap: () {},
        child: VendorLiveBlurContainer(
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: AppText( text: 
              "View Offer",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
