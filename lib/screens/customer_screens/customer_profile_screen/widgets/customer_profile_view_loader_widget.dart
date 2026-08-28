import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_asserts_icons_path.dart';
import 'package:nexprime/constant/app_asserts_image_path.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/screens/customer_screens/customer_profile_screen/widgets/profile_widgets.dart';

import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/app_image/app_image_circular.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomerProfileViewLoaderWidget extends StatelessWidget {
  const CustomerProfileViewLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            // expandedHeight: AppSize.size.height * 0.28,
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
                  // top: AppSize.size.height * 0.05,
                  top: 70,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {},
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
                        //  color: AppColors.instance.white50,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.instance.error, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: AppImageCircular(width: AppSize.size.width * 0.28, height: AppSize.size.width * 0.28),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: DecoratedBox(
              decoration: BoxDecoration(color: AppColors.instance.white50),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    AppText(text: "No name", fontSize: AppSize.size.width * 0.053, color: AppColors.instance.black06, fontWeight: FontWeight.w600),
                    Gap(height: 12),

                    ProfileWidget(
                      title: 'My Product',
                      onTap: () {},
                      child: Icon(Icons.storefront_rounded, color: AppColors.instance.green, size: AppSize.size.width * 0.08),
                    ),
                    Gap(height: 12),

                    ProfileWidget(
                      title: 'Messages',
                      onTap: () {},
                      child: Icon(Icons.message_outlined, color: AppColors.instance.green, size: AppSize.size.width * 0.08),
                    ),
                    Gap(height: 12),

                    ProfileWidget(
                      title: 'Following shops',
                      onTap: () {},
                      child: Icon(Icons.storefront_rounded, color: AppColors.instance.green, size: AppSize.size.width * 0.08),
                    ),

                    Gap(height: 12),
                    ProfileWidget(
                      title: 'Language',
                      subtitle: 'English',
                      onTap: () {},
                      child: AppImage(path: AppAssertsIconsPath.instance.worldIcon, fit: BoxFit.cover),
                    ),
                    Gap(height: 12),
                    ProfileWidget(
                      title: 'Privacy & Policy',
                      subtitle: 'Legal Docs',
                      onTap: () {},
                      child: AppImage(path: AppAssertsIconsPath.instance.privacyIcon, fit: BoxFit.cover),
                    ),
                    Gap(height: 12),
                    ProfileWidget(
                      title: 'Terms & conditions',
                      subtitle: 'Legal Docs',
                      onTap: () {},
                      child: AppImage(path: AppAssertsIconsPath.instance.privacyIcon, fit: BoxFit.cover),
                    ),
                    Gap(height: 12),
                    ProfileWidget(
                      title: 'About Us',
                      subtitle: 'Legal Docs',
                      onTap: () {},
                      child: AppImage(path: AppAssertsIconsPath.instance.faqIcon, fit: BoxFit.cover),
                    ),
                    Gap(height: 12),
                    ProfileWidget(
                      title: 'FAQ',
                      subtitle: 'All you need to know, right here',
                      onTap: () {},
                      child: AppImage(path: AppAssertsIconsPath.instance.faqIcon, fit: BoxFit.cover),
                    ),
                    Gap(height: 12),
                    ProfileWidget(
                      title: 'Help & support',
                      subtitle: 'Email Support',
                      onTap: () {},
                      child: AppImage(path: AppAssertsIconsPath.instance.supportIcon, fit: BoxFit.cover),
                    ),
                    Gap(height: 15),

                    AppButton(
                      onTap: () async {},
                      height: AppSize.size.height * 0.056,
                      title: "Logout",
                      titleColor: AppColors.instance.redF7,
                      backgroundColor: AppColors.instance.white50,
                      borderColor: AppColors.instance.redF7,
                    ),
                    Gap(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
