import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constant/app_colors.dart';
import '../../../../utils/app_size.dart';
import '../../../../utils/gap.dart';
import '../../../../widgets/texts/app_text.dart';
import '../provider/cloth_details_provider.dart';

class CustomSizedPanel extends StatelessWidget {
  const CustomSizedPanel({
    super.key,
    required this.sizes,
    required this.sizeIndex,
    required this.ref,
  });

  final List<String> sizes;
  final int sizeIndex;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: "Size",
          fontSize: AppSize.size.width * 0.042,
          fontWeight: FontWeight.bold,
        ),
        Gap(width: AppSize.size.width * 0.022),
        Expanded(
          child: Wrap(
            spacing: 12,
            runSpacing: 10,
            children: List.generate(sizes.length, (index) {
              bool isSelected = sizeIndex == index;
              return GestureDetector(
                onTap: () {
                  ref.read(sizeProvider.notifier).state =index;
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.size.width * 0.04,
                    vertical: AppSize.size.width * 0.012,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xffdcdcdc)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    sizes[index],
                    style: TextStyle(
                      fontSize: AppSize.size.width * 0.032,
                      color: AppColors.instance.black06,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}