import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_asserts_icons_path.dart';
import 'package:nexprime/constant/app_asserts_image_path.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/screens/customer_screens/customer_profile_screen/provider/customer_profile_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_profile_screen/widgets/profile_widgets.dart';
import 'package:nexprime/services/storage/storage_services.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/app_image/app_image_circular.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constant/app_colors.dart';
import '../../../utils/app_size.dart';

class CustomerProfileScreen extends ConsumerStatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  ConsumerState<CustomerProfileScreen> createState() =>
      _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends ConsumerState<CustomerProfileScreen> {
  bool isGuest = true;

  Future<void> onAppInitial() async {
    try {
      var role = await StorageServices.instance.getAppRoll();
      setState(() {
        isGuest = role.toLowerCase() == "guest";
      });
    } catch (e) {
      errorLog("onAppInitial", e);
    }
  }

  void login() {
    AppRoutes.instance.go(AppRoutesKey.instance.signInScreen);
    ref.invalidate(customerProfileProvider);
  }

  Future<void> logout() async {
    try {
      await StorageServices.instance.logout();
      AppRoutes.instance.go(AppRoutesKey.instance.signInScreen);
    } catch (e) {
      errorLog("error is", e);
    }
  }

  @override
  void initState() {
    super.initState();
    onAppInitial();
  }

  Future<void> openSupportEmail() async {
    final Uri emailUri = Uri.parse(
      'mailto:chremon84@gmail.com?subject=Support Request&body=Hello, I need help...',
    );
    await launchUrl(emailUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(customerProfileProvider);


    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            if (!isGuest)
              SliverAppBar(
                automaticallyImplyLeading: false,
              //  expandedHeight: AppSize.size.height * 0.33,
                expandedHeight: AppSize.size.height * 0.18,
                leadingWidth: 0,
                flexibleSpace: Stack(
                  children: [
                    AppImage(
                      width: AppSize.size.width,
                      height: AppSize.size.height * 0.328,
                      isZomBle: true,
                      url: profile?.coverImageUrl,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: AppSize.size.height * 0.05,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          AppRoutes.instance.pushNamed(
                            AppRoutesKey.instance.customerEditProfileScreen,
                          );
                        },
                        child: AppButton(
                          backgroundColor: AppColors.instance.green,
                          borderColor: AppColors.instance.green,
                          child: Row(
                            children: [
                              Image.asset(
                                AppAssertsIconsPath.instance.editIcon,
                                scale: 5,
                              ),
                              Gap(width: AppSize.size.width * 0.02),
                              AppText(
                                text: "Edit Profile",
                                color: AppColors.instance.white50,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // bottom: PreferredSize(
                //   preferredSize: Size.fromHeight(AppSize.size.width * 0.3),
                //   child: Stack(
                //     alignment: Alignment.center,
                //     children: [
                //       Gap(width: AppSize.size.width),
                //       Positioned(
                //         bottom: 0,
                //         child: Container(
                //           height: AppSize.size.width * 0.15,
                //           width: AppSize.size.width,
                //           decoration: BoxDecoration(
                //             color: AppColors.instance.white50,
                //             borderRadius: const BorderRadius.only(
                //               topLeft: Radius.circular(20),
                //               topRight: Radius.circular(20),
                //             ),
                //           ),
                //         ),
                //       ),
                //
                //       Container(
                //         decoration: BoxDecoration(
                //           border: Border.all(
                //             color: AppColors.instance.error,
                //             width: 2,
                //           ),
                //           shape: BoxShape.circle,
                //         ),
                //         child: AppImageCircular(
                //           width: AppSize.size.width * 0.3,
                //           height: AppSize.size.width * 0.30,
                //           url: profile?.profileImageUrl,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
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
                      if (!isGuest)
                        ProfileWidget(
                          title: 'My Product',
                          onTap: () {
                            AppRoutes.instance.pushNamed(
                              AppRoutesKey.instance.customerMyProductScreen,
                            );
                          },
                          child: Icon(
                            Icons.storefront_rounded,
                            color: AppColors.instance.green,
                            size: AppSize.size.width * 0.08,
                          ),
                        ),
                      if (!isGuest) Gap(height: 12),
                      if (!isGuest)
                        ProfileWidget(
                          title: 'Message',
                          onTap: () {
                            AppRoutes.instance.pushNamed(
                              AppRoutesKey.instance.customerMessageScreen,
                            );
                          },
                          child: Icon(
                            Icons.message_outlined,
                            color: AppColors.instance.green,
                            size: AppSize.size.width * 0.08,
                          ),
                        ),
                      if (!isGuest) Gap(height: 12),
                      if (!isGuest)
                        ProfileWidget(
                          title: 'Following shops',
                          onTap: () {
                            AppRoutes.instance.pushNamed(
                              AppRoutesKey.instance.customerFollowShopList,
                            );
                          },
                          child: Icon(
                            Icons.storefront_rounded,
                            color: AppColors.instance.green,
                            size: AppSize.size.width * 0.08,
                          ),
                        ),
                      if (!isGuest) Gap(height: 12),
                      if (!isGuest)
                        ProfileWidget(
                          title: 'Address',
                          subtitle: '1 set',
                          onTap: () {},
                          child: AppImage(
                            path: AppAssertsImagePath.instance.homeImage,
                            fit: BoxFit.cover,
                          ),
                        ),
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
                          AppRoutes.instance.pushNamed(
                            AppRoutesKey.instance.changeLanguageScreen,
                          );
                        },
                        child: AppImage(
                          path: AppAssertsIconsPath.instance.worldIcon,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Gap(height: 12),
                      ProfileWidget(
                        title: 'Privacy & Policy',
                        subtitle: 'Legal Docs',
                        onTap: () {
                          AppRoutes.instance.pushNamed(
                            AppRoutesKey.instance.customerPrivacyPolicy,
                          );
                        },
                        child: AppImage(
                          path: AppAssertsIconsPath.instance.privacyIcon,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Gap(height: 12),
                      ProfileWidget(
                        title: 'Terms & conditions',
                        subtitle: 'Legal Docs',
                        onTap: () {
                          AppRoutes.instance.pushNamed(
                            AppRoutesKey.instance.customerTermsConditions,
                          );
                        },
                        child: AppImage(
                          path: AppAssertsIconsPath.instance.privacyIcon,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Gap(height: 12),
                      ProfileWidget(
                        title: 'FAQ',
                        subtitle: 'All you need to know, right here',
                        onTap: () {
                          AppRoutes.instance.pushNamed(
                            AppRoutesKey.instance.customerFaqScreen,
                          );
                        },
                        child: AppImage(
                          path: AppAssertsIconsPath.instance.faqIcon,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Gap(height: 12),
                      ProfileWidget(
                        title: 'Help & support',
                        subtitle: 'Email Support',
                        onTap: () {
                          openSupportEmail();
                        },
                        child: AppImage(
                          path: AppAssertsIconsPath.instance.supportIcon,
                          fit: BoxFit.cover,
                        ),
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
                      Gap(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
