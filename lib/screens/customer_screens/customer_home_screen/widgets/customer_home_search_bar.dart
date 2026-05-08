import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/utils/app_size.dart';

class CustomSearchBar extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onLastIconTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool showLastIcon;
  final String hintText;
  final TextEditingController? controller;

  const CustomSearchBar({
    super.key,
    this.onSearchTap,
    this.onLastIconTap,
    this.onChanged,
    this.onSubmitted,
    this.showLastIcon = false,
    this.hintText = "Search",
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: AppSize.size.height * 0.053,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.instance.gray100,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onSearchTap,
            child: Icon(
              Icons.search,
              color: AppColors.instance.gray300,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.black),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),

          if (showLastIcon)
            GestureDetector(
              onTap: onLastIconTap,
              child: Icon(
                Icons.close,
                color: AppColors.instance.gray300,
              ),
            ),
        ],
      ),
    );
  }
}
