import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_asserts_icons_path.dart';
import 'package:nexprime/constant/app_asserts_image_path.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/models/vendor_store_model.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/app_image/app_image_circular.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

class VendorProfileAppBar extends StatelessWidget {
  final AsyncValue<VendorStoreModel?> vendorStoreAsync;

  const VendorProfileAppBar({super.key, required this.vendorStoreAsync});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.instance.white400,
      automaticallyImplyLeading: false,
      expandedHeight: AppSize.size.height * 0.22,
      leadingWidth: 0,
      flexibleSpace: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: AppSize.size.width * 0.30),
            child: Align(
              child: AppImage(
                width: AppSize.size.width * 0.7,
                height: AppSize.size.height * 0.328,
                isZomBle: true,
                path: AppAssertsImagePath.instance.appLogo,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          Positioned(
            top: 70,
            right: 16,
            child: GestureDetector(
              onTap: () {
                AppRoutes.instance.pushNamed(AppRoutesKey.instance.vendorEditProfileScreen);
              },
              child: AppButton(
                backgroundColor: AppColors.instance.green,
                borderColor: AppColors.instance.green,
                child: Row(
                  children: [
                    Image.asset(AppAssertsIconsPath.instance.editIcon, scale: 5),
                    Gap(width: AppSize.size.width * 0.02),
                    AppText(text: "Edit Profile", color: AppColors.instance.white50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(AppSize.size.width * 0.28),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Gap(width: AppSize.size.width),
            Positioned(
              bottom: 0,
              child: Container(
                height: AppSize.size.width * 0.15,
                width: AppSize.size.width,
                decoration: BoxDecoration(
                  color: AppColors.instance.white50,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.instance.error, width: 2),
                shape: BoxShape.circle,
              ),
              child: vendorStoreAsync.when(
                data: (vendorStore) => AppImageCircular(
                  width: AppSize.size.width * 0.25,
                  height: AppSize.size.width * 0.25,
                  url: vendorStore?.photo ?? "assets/dev_image/vendor_profile_image.png",
                ),
                loading: () => AppImageCircular(
                  width: AppSize.size.width * 0.25,
                  height: AppSize.size.width * 0.25,
                  path: "assets/dev_image/vendor_profile_image.png",
                ),
                error: (e, st) => AppImageCircular(
                  width: AppSize.size.width * 0.25,
                  height: AppSize.size.width * 0.25,
                  path: "assets/dev_image/vendor_profile_image.png",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
