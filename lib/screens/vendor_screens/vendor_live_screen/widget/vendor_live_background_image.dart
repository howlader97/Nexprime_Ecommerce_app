import 'package:flutter/material.dart';

class VendorLiveBackgroundImage extends StatelessWidget {
  const VendorLiveBackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.network(
        "https://images.unsplash.com/photo-1504674900247-0877df9cc836",
        fit: BoxFit.cover,
      ),
    );
  }
}
