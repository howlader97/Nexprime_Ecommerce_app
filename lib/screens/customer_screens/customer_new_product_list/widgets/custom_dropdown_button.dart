import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../../../utils/app_size.dart';

class CustomDropDownButton extends StatelessWidget {
  final List<String> items;
  final String? value;
  final String hintText;
  final String? header;
  final String? errorText;
  final Widget? prefixIcon;
  final bool isEnabled;
  final Function(String?) onChanged;
  final EdgeInsets? padding;

  const CustomDropDownButton({
    super.key,
    this.padding,
    required this.items,
    required this.onChanged,
    this.value,
    this.hintText = "Select Item",
    this.errorText,
    this.prefixIcon,
    this.isEnabled = true,
    this.header,

  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    final double fontSize = isTablet ? 16 : 14;
    final double buttonHeight = isTablet
        ? AppSize.height(value: 60)
        : AppSize.height(value: 50);
    final double iconSize = isTablet ? 26 : 22;

    return Padding(
      padding:padding ?? EdgeInsets.symmetric(
        horizontal: AppSize.size.width * 0.046,
        vertical: AppSize.size.width * 0.025,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: header ?? "",
            fontSize: AppSize.size.width * 0.042,
            fontWeight: FontWeight.bold,
          ),
          Gap(height: 6),
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              value: value,
              hint: Text(
                hintText,
                style: TextStyle(fontSize: fontSize, color: Colors.grey),
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: isEnabled ? onChanged : null,

              /// Button Style
              buttonStyleData: ButtonStyleData(
                height: buttonHeight,
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.width(value: 8)),
                  border: Border.all(
                    color: errorText != null
                        ? AppColors.instance.redF7
                        : AppColors.instance.black900,
                  ),
                  color: isEnabled ? Colors.transparent : Colors.grey.shade200,
                ),
              ),

              /// Icon Style
              iconStyleData: IconStyleData(
                icon: const Icon(Icons.keyboard_arrow_down),
                iconSize: iconSize,
                iconEnabledColor: AppColors.instance.black900,
                iconDisabledColor: AppColors.instance.gray50,
              ),

              /// Dropdown Style
              dropdownStyleData: DropdownStyleData(
                maxHeight: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                offset: const Offset(0, -5),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: WidgetStateProperty.all(6),
                ),
              ),

              menuItemStyleData: MenuItemStyleData(
                height: isTablet ? 50 : 45,
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 14),
              ),
            ),
          ),

          /// Error Tex
          if (errorText != null) ...[
            const SizedBox(height: 6),
            Text(
              errorText!,
              style: TextStyle(color: Colors.red, fontSize: isTablet ? 14 : 12),
            ),
          ],
        ],
      ),
    );
  }
}
