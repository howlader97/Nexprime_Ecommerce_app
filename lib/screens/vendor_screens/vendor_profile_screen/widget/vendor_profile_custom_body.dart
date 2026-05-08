import 'package:flutter/material.dart';
import 'package:nexprime/screens/vendor_screens/vendor_profile_screen/widget/vendor_profile-statItem.dart';
import 'package:nexprime/screens/vendor_screens/vendor_profile_screen/widget/vendor_profile_rating.dart';

import 'package:nexprime/models/vendor_store_model.dart';

import '../../../../utils/gap.dart';
import '../../../../widgets/texts/app_text.dart';

class VendorProfileCustomBody extends StatelessWidget {
  final Function() onTap;
  final VendorStoreModel? vendorStore;
  final dynamic likes;

  const VendorProfileCustomBody({
    super.key,
    required this.onTap,
    this.vendorStore,
    this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: AppText(
            text: vendorStore?.name ?? "Green Thumb",
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(height: 8),
        Center(
          child: AppText(
            textAlign: TextAlign.center,
            text: vendorStore?.bio ??
                "Upgrade your home with Green Thumb. We sell high-quality electronics that last long and save electricity. From small ovens to big refrigerators, we have it all. Visit us or order online for fast delivery! 🚚",
          ),
        ),
        Gap(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            VendorProfileStatItem(
              value: vendorStore?.followers.toString() ?? "0",
              label: "Followers",
            ),
             VendorProfileStatItem(
                 value: vendorStore?.followerCount.toString() ?? "0",
                 label: "Following"),
             VendorProfileStatItem(
                 value: likes?.toString() ?? "0",
                 label: "Likes"),
          ],
        ),
        Gap(height: 16),
       // VendorProfileRating(onTap: onTap),
      ],
    );
  }
}
