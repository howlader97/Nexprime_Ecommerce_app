import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/provider/nav_provider.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../../../constant/app_colors.dart';

class VendorAppBar extends ConsumerWidget {
  final void Function()? onPressed;
  final String title;
  final bool isButton;
  final bool isBack;

  const VendorAppBar({
    super.key,
    this.onPressed,
    required this.title,
    this.isButton = false,
    this.isBack = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (isBack == true)
              IconButton(
                onPressed: () {
                  ref.read(navIndexProvider.notifier).state = 0;
                  AppRoutes.instance.go(
                    AppRoutesKey.instance.appNavigationScreen,
                  );
                },
                icon: const Icon(Icons.arrow_back),
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.instance.white50,
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppSize.width(value: 8),
                    ),
                  ),
                ),
              ),
            AppText(
              text: title,
              fontSize: AppSize.width(value: 20),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ],
        ),
        if (isButton)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.instance.white50,
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.width(value: 8)),
              ),
            ),
            onPressed: onPressed,
            child: AppText(
              text: "Add Product",
              color: AppColors.instance.white50,
            ),
          ),
      ],
    );
  }
}
