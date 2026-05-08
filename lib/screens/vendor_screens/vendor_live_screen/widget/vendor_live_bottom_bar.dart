import 'package:flutter/material.dart';
import '../../../../constant/app_colors.dart';
import '../../../../utils/app_size.dart';
import '../../../../widgets/texts/app_text.dart';

class VendorLiveBottomBar extends StatelessWidget {
  const VendorLiveBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: EdgeInsets.symmetric(
        vertical: AppSize.size.height * 0.02,
        horizontal: AppSize.size.width * 0.02,
      ),
      decoration: BoxDecoration(
        color: AppColors.instance.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const PinComment(),
          Row(
            children: [
              IconButtonBox(icon: Icons.camera_alt_outlined, onTap: () {}),

              const SizedBox(width: 10),

              IconButtonBox(icon: Icons.mic_none_outlined, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class PinComment extends StatelessWidget {
  const PinComment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          AppText(text: "Pin Comment  "),
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFF9C27B0),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.send, color: Colors.white, size: 15),
          ),
        ],
      ),
    );
  }
}

class IconButtonBox extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const IconButtonBox({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }
}
