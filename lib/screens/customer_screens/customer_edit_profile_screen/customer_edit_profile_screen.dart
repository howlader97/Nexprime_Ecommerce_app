import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/screens/customer_screens/customer_edit_profile_screen/provider/edit_profile_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_profile_screen/provider/customer_profile_provider.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/buttons/icon_button_widget.dart';
import 'package:nexprime/widgets/inputs/app_input_widget_tow.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import '../../../constant/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_size.dart';
import '../../../utils/gap.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/app_image/app_image_circular.dart';
import '../../../widgets/image_userPick/image_user_pick.dart';

class CustomerEditProfileScreen extends ConsumerStatefulWidget {
  const CustomerEditProfileScreen({super.key});

  @override
  ConsumerState<CustomerEditProfileScreen> createState() =>
      _CustomerEditProfileScreenState();
}

class _CustomerEditProfileScreenState
    extends ConsumerState<CustomerEditProfileScreen> {
  late TextEditingController nameTEController;
  late TextEditingController passwordTEController;
  late TextEditingController phoneTEController;
  late TextEditingController location;

  String? profileImagePath;
  String? coverImagePath;

  @override
  void initState() {
    nameTEController = TextEditingController();
    passwordTEController = TextEditingController();
    phoneTEController = TextEditingController();
    location = TextEditingController();


    // Populate initial data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileData = ref.read(customerProfileProvider);
      if (profileData != null) {
        setState(() {
          nameTEController.text = profileData.fullname;
          phoneTEController.text = profileData.phonenumber;
          location.text = profileData.locaion ?? '';

        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    nameTEController.dispose();
    passwordTEController.dispose();
    phoneTEController.dispose();
    location.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(editProfileProvider);
    final profileData = ref.watch(customerProfileProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: AppSize.size.height * 0.27,
              flexibleSpace: Stack(
                children: [
                  coverImagePath != null
                      ? AppImage(
                    filePath: coverImagePath,
                    width: AppSize.size.width,
                    isZomBle: true,
                  )
                      : AppImage(
                    width: AppSize.size.width,
                    isZomBle: true,
                    url: profileData?.coverImageUrl ?? "",
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: AppSize.size.height * 0.05,
                    left: 16,
                    child: IconButtonWidget(
                      onTap: () {
                        AppRoutes.instance.pop();
                      },
                      icon: Icons.arrow_back,
                    ),
                  ),
                  Positioned(
                    top: AppSize.size.height * 0.05,
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        appImageUserTake(
                          callBack: (v) {
                            setState(() {
                              coverImagePath = v;
                            });
                          },
                        );
                      },
                      child: IconButtonWidget(icon: Icons.image_rounded),
                    ),
                  ),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(AppSize.size.width * 0.25),
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
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.instance.error,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: profileImagePath != null
                          ? AppImageCircular(
                        filePath: profileImagePath,
                        width: AppSize.size.width * 0.28,
                        height: AppSize.size.width * 0.28,
                      )
                          : AppImageCircular(
                        width: AppSize.size.width * 0.27,
                        height: AppSize.size.width * 0.27,
                        url: profileData?.profileImageUrl ?? "",
                      ),
                    ),
                    Positioned(
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            appImageUserTake(
                              callBack: (v) {
                                setState(() {
                                  profileImagePath = v;
                                });
                              },
                            );
                          },
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            size: 36,
                            color: AppColors.instance.white50,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: DecoratedBox(
                decoration: BoxDecoration(color: AppColors.instance.white50),
                child: Column(
                  children: [
                    AppInputWidgetTwo(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      titleFontWeight: FontWeight.bold,
                      title: "Full Name",
                      hintText: "Enter your Name",
                      controller: nameTEController,
                    ),
                    AppInputWidgetTwo(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      titleFontWeight: FontWeight.bold,
                      title: "password",
                      hintText: "Enter your password",
                      controller: passwordTEController,
                    ),
                    AppInputWidgetTwo(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      titleFontWeight: FontWeight.bold,
                      controller: phoneTEController,
                      title: "Phone Number ",
                      hintText: "Enter your number",
                    ),
                    AppInputWidgetTwo(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      titleFontWeight: FontWeight.bold,
                      controller: location,
                      title: "Location ",
                      hintText: "Enter name Country,City",
                    ),

                    Padding(
                      padding: EdgeInsets.all(AppSize.size.width * 0.04),
                      child: AppButton(
                        height: AppSize.size.width * 0.132,
                        backgroundColor: AppColors.instance.green,
                        borderColor: AppColors.instance.green,
                        title: profile.isLoading
                            ? "Updating..."
                            : "Save Changes",
                        onTap: profile.isLoading
                            ? null
                            : () async {
                          final body = {
                            "fullname": nameTEController.text,
                            "phonenumber": phoneTEController.text,
                            "location": location.text,
                          };
                          if (passwordTEController.text.isNotEmpty) {
                            body["password"] = passwordTEController.text;
                          }
                          await ref
                              .read(editProfileProvider.notifier)
                              .updateProfile(
                            body: body,
                            profileImagePath: profileImagePath,
                            coverImagePath: coverImagePath,
                          );
                          final result = ref.read(editProfileProvider);

                          result.when(
                            data: (success) {
                              if (success) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(
                                  const SnackBar(
                                    content: AppText(
                                      text: "Profile Updated",
                                    ),
                                  ),
                                );
                                AppRoutes.instance.pop();
                              }
                            },
                            loading: () {},
                            error: (e, _) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: AppText(text: e.toString()),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
