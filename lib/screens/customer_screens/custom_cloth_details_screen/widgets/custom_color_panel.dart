import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/utils/gap.dart';

import '../../../../utils/app_size.dart';
import '../../../../widgets/texts/app_text.dart';
import '../provider/cloth_details_provider.dart';

class CustomColorPanel extends StatelessWidget {
  const CustomColorPanel({
    super.key,
    required this.colors,
    required this.colorIndex,
    required this.ref,
  });

  final List<Color> colors;
  final int colorIndex;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(
          text: "Color",
          fontSize: AppSize.size.width * 0.042,
          fontWeight: FontWeight.bold,
        ),
        Gap(width: AppSize.size.width * 0.04),
        Row(
          children: List.generate(colors.length, (index) {
            bool isSelected = colorIndex == index;
            return GestureDetector(
              onTap: () {
                ref.read(colorProvider.notifier).state =index;
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Colors.green
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: colors[index],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}