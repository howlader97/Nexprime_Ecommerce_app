import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/screens/vendor_screens/vendor_edit_profile_screen/provider/edit_profile_provider.dart';
import 'package:nexprime/screens/vendor_screens/vendor_profile_screen/provider/vendor_profile_provider.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/buttons/icon_button_widget.dart';
import 'package:nexprime/widgets/inputs/app_input_widget_tow.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import '../../../../constant/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_size.dart';
import '../../../../utils/gap.dart';
import '../../../../widgets/app_image/app_image.dart';
import '../../../../widgets/app_image/app_image_circular.dart';
import '../../../../widgets/image_userPick/image_user_pick.dart';

class VendorEditProfileScreen extends ConsumerStatefulWidget {
  const VendorEditProfileScreen({super.key});

  @override
  ConsumerState<VendorEditProfileScreen> createState() => _VendorEditProfileScreenState();
}

class _VendorEditProfileScreenState extends ConsumerState<VendorEditProfileScreen> {
  late TextEditingController storeNameTEController;
  late TextEditingController storeBioTextEditingController;
  late TextEditingController storeAddressTextController;

  String? profileImageFilePath;
  String? coverImageFilePath;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    storeNameTEController = TextEditingController();
    storeBioTextEditingController = TextEditingController();
    storeAddressTextController = TextEditingController();
  }

  @override
  void dispose() {
    storeNameTEController.dispose();
    storeBioTextEditingController.dispose();
    storeAddressTextController.dispose();
    super.dispose();
  }

  void _initializeData(WidgetRef ref) {
    final storeAsync = ref.read(vendorStoreProvider);
    storeAsync.whenData((store) {
      if (store != null && !_isInitialized) {
        storeNameTEController.text = store.name;
        storeBioTextEditingController.text = store.bio ?? "";
        storeAddressTextController.text = store.address ?? "";
        _isInitialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize data if not already done
    if (!_isInitialized) {
      _initializeData(ref);
    }

    final storeAsync = ref.watch(vendorStoreProvider);
    final editState = ref.watch(vendorEditStoreProvider);

    return Scaffold(
      body: SafeArea(
        child: storeAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, st) => Center(child: AppText(text: "Error: $err")),
          data: (store) {
            if (store == null) return const Center(child: AppText(text: "No store data found"));

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: AppSize.size.height * 0.35,
                  flexibleSpace: Stack(
                    children: [
                      // Cover Image
                      coverImageFilePath != null
                          ? AppImage(filePath: coverImageFilePath ?? "", width: AppSize.size.width, isZomBle: true)
                          : AppImage(width: AppSize.size.width, isZomBle: true, url: store.coverImgUrl ?? "", fit: BoxFit.cover),
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
                                  coverImageFilePath = v;
                                });
                              },
                            );
                          },
                          child: const IconButtonWidget(icon: Icons.image_rounded),
                        ),
                      ),
                    ],
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(AppSize.size.width * 0.3),
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
                        // Profile Image
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.instance.error, width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: profileImageFilePath != null
                              ? AppImageCircular(filePath: profileImageFilePath, width: AppSize.size.width * 0.3, height: AppSize.size.width * 0.30)
                              : AppImageCircular(width: AppSize.size.width * 0.3, height: AppSize.size.width * 0.30, url: store.photo),
                        ),
                        Positioned(
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                appImageUserTake(
                                  callBack: (v) {
                                    setState(() {
                                      profileImageFilePath = v;
                                    });
                                  },
                                );
                              },
                              icon: Icon(Icons.camera_alt_outlined, size: 36, color: AppColors.instance.white50),
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
                          titleFontWeight: FontWeight.bold,
                          title: "Store Name",
                          hintText: "Enter Store Name",
                          controller: storeNameTEController,
                        ),
                        AppInputWidgetTwo(
                          titleFontWeight: FontWeight.bold,
                          controller: storeAddressTextController,
                          title: "Store Address",
                          hintText: "Enter Address",
                        ),
                        AppInputWidgetTwo(
                          titleFontWeight: FontWeight.bold,
                          title: "Store Bio",
                          hintText: "Enter Bio",
                          controller: storeBioTextEditingController,
                        ),
                        Padding(
                          padding: EdgeInsets.all(AppSize.size.width * 0.04),
                          child: AppButton(
                            height: AppSize.size.width * 0.14,
                            backgroundColor: AppColors.instance.green,
                            borderColor: AppColors.instance.green,
                            title: 'Save changes',
                            isLoading: editState.isLoading,
                            onTap: () async {
                              final success = await ref
                                  .read(vendorEditStoreProvider.notifier)
                                  .updateStoreProfile(
                                    name: storeNameTEController.text,
                                    bio: storeBioTextEditingController.text,
                                    address: storeAddressTextController.text,
                                    photo: profileImageFilePath != null ? File(profileImageFilePath!) : null,
                                    coverPhoto: coverImageFilePath != null ? File(coverImageFilePath!) : null,
                                  );
                              if (success && mounted) {
                                AppRoutes.instance.pop();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
