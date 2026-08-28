import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_asserts_icons_path.dart';
import 'package:nexprime/constant/app_asserts_image_path.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/models/customer_profile_model.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/screens/customer_screens/customer_profile_screen/widgets/profile_widgets.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/app_image/app_image_circular.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

class CustomerProfileViewWidget extends StatelessWidget {
  const CustomerProfileViewWidget({
    super.key,
    required this.isGuest,
    required this.profile,
    required this.login,
    required this.logout,
    required this.openSupportEmail,
  });
  final bool isGuest;
  final CustomerProfileModel? profile;
  final void Function() login;
  final void Function() logout;
  final void Function() openSupportEmail;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        if (!isGuest)
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
                    onTap: () {
                      AppRoutes.instance.pushNamed(AppRoutesKey.instance.customerEditProfileScreen);
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
                    child: AppImageCircular(width: AppSize.size.width * 0.28, height: AppSize.size.width * 0.28, url: profile?.profileImageUrl),
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
                  if (isGuest) Gap(height: 20),
                  if (isGuest)
                    AppButton(
                      onTap: () {
                        login();
                      },
                      height: AppSize.size.height * 0.056,
                      title: "Login",
                      titleColor: AppColors.instance.white50,
                      backgroundColor: AppColors.instance.green,
                      borderColor: AppColors.instance.green,
                    ),
                  if (isGuest) Gap(height: 20),
                  if (!isGuest)
                    AppText(
                      text: profile?.fullname ?? "No name",
                      fontSize: AppSize.size.width * 0.053,
                      color: AppColors.instance.black06,
                      fontWeight: FontWeight.w600,
                    ),
                  if (!isGuest) Gap(height: 12),
                //  if (!isGuest) CustomerBalanceCard(),
                  if (!isGuest) Gap(height: 12),
                  if (!isGuest)
                    ProfileWidget(
                      title: 'My Product',
                      onTap: () {
                        AppRoutes.instance.pushNamed(AppRoutesKey.instance.customerMyProductScreen);
                      },
                      child: Icon(Icons.storefront_rounded, color: AppColors.instance.green, size: AppSize.size.width * 0.08),
                    ),
                  if (!isGuest) Gap(height: 12),
                  if (!isGuest)
                    ProfileWidget(
                      title: 'Messages',
                      onTap: () {
                        AppRoutes.instance.pushNamed(AppRoutesKey.instance.customerMessageScreen);
                      },
                      child: Icon(Icons.message_outlined, color: AppColors.instance.green, size: AppSize.size.width * 0.08),
                    ),
                  if (!isGuest) Gap(height: 12),
                  if (!isGuest)
                    ProfileWidget(
                      title: 'Following shops',
                      onTap: () {
                        AppRoutes.instance.pushNamed(AppRoutesKey.instance.customerFollowShopList);
                      },
                      child: Icon(Icons.storefront_rounded, color: AppColors.instance.green, size: AppSize.size.width * 0.08),
                    ),
                  // if (!isGuest) Gap(height: 12),
                  // if (!isGuest)
                  //   ProfileWidget(
                  //     title: 'Address',
                  //     subtitle: '1 set',
                  //     onTap: () {},
                  //     child: AppImage(
                  //       path: AppAssertsImagePath.instance.homeImage,
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // if (!isGuest) Gap(height: 12),
                  // if (!isGuest)
                  //   ProfileWidget(
                  //     title: 'Payment',
                  //     subtitle: 'Verified',
                  //     onTap: () {},
                  //     child: AppImage(
                  //       path: AppAssertsImagePath.instance.creditCard,
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  Gap(height: 12),
                  ProfileWidget(
                    title: 'Language',
                    subtitle: 'English',
                    onTap: () {
                      AppRoutes.instance.pushNamed(AppRoutesKey.instance.changeLanguageScreen);
                    },
                    child: AppImage(path: AppAssertsIconsPath.instance.worldIcon, fit: BoxFit.cover),
                  ),
                  Gap(height: 12),
                  ProfileWidget(
                    title: 'Privacy & Policy',
                    subtitle: 'Legal Docs',
                    onTap: () {
                      AppRoutes.instance.pushNamed(AppRoutesKey.instance.customerPrivacyPolicy);
                    },
                    child: AppImage(path: AppAssertsIconsPath.instance.privacyIcon, fit: BoxFit.cover),
                  ),
                  Gap(height: 12),
                  ProfileWidget(
                    title: 'Terms & conditions',
                    subtitle: 'Legal Docs',
                    onTap: () {
                      AppRoutes.instance.pushNamed(AppRoutesKey.instance.customerTermsConditions);
                    },
                    child: AppImage(path: AppAssertsIconsPath.instance.privacyIcon, fit: BoxFit.cover),
                  ),
                  Gap(height: 12),
                  ProfileWidget(
                    title: 'About Us',
                    subtitle: 'Legal Docs',
                    onTap: () {
                      AppRoutes.instance.pushNamed(AppRoutesKey.instance.customerAboutUsScreen);
                    },
                    child: AppImage(path: AppAssertsIconsPath.instance.faqIcon, fit: BoxFit.cover),
                  ),
                  Gap(height: 12),
                  ProfileWidget(
                    title: 'FAQ',
                    subtitle: 'All you need to know, right here',
                    onTap: () {
                      AppRoutes.instance.pushNamed(AppRoutesKey.instance.customerFaqScreen);
                    },
                    child: AppImage(path: AppAssertsIconsPath.instance.faqIcon, fit: BoxFit.cover),
                  ),
                  Gap(height: 12),
                  ProfileWidget(
                    title: 'Help & support',
                    subtitle: 'Email Support',
                    onTap: () {
                      openSupportEmail();
                    },
                    child: AppImage(path: AppAssertsIconsPath.instance.supportIcon, fit: BoxFit.cover),
                  ),
                  Gap(height: 15),
                  if (!isGuest)
                    AppButton(
                      onTap: () async {
                        logout();
                      },
                      height: AppSize.size.height * 0.056,
                      title: "Logout",
                      titleColor: AppColors.instance.redF7,
                      backgroundColor: AppColors.instance.white50,
                      borderColor: AppColors.instance.redF7,
                    ),
                  if (!isGuest) Gap(height: 12),
                  if (!isGuest)
                    AppButton(
                      onTap: () async {

                      },
                      height: AppSize.size.height * 0.056,
                      title: "Delete account",
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
    );
  }
}
