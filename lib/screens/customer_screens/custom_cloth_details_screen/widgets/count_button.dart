import 'package:flutter/material.dart';

import '../../../../constant/app_colors.dart';
import '../../../../utils/app_size.dart';

class CountButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  const CountButton({
    super.key, required this.onTap, required this.icon,
  });



  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color:  Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.size.width * 0.04,
          vertical: AppSize.size.width * 0.012,
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Icon(
            icon,
            color: AppColors.instance.black06,
            size: 20,
            fontWeight:  FontWeight.w500,
          ),
        ),
      ),
    );
  }
}