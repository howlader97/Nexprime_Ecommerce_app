import 'package:flutter/material.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

class CustomerHomeCountryCard extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onTap;
  const CustomerHomeCountryCard({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
          child: AppImage(
                url: image,
                height: AppSize.size.width * 0.15,
                width: AppSize.size.width * 0.2,
                fit: BoxFit.cover,
              ),
            ),
          Gap(height:  AppSize.size.width * 0.012,),
            SizedBox(
              width: AppSize.size.width * 0.2,
              child: AppText(
                text: title,
                maxLines: 1,
                  fontSize: AppSize.size.width * 0.035,
                 // textScaleFactor: 0.9,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
            ),
          ],
        ),
      ),
    );
  }
}


