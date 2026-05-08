import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/constant/app_constant.dart';
import 'package:nexprime/screens/auth_screen/sign_up_screen/provider/sign_up_provider.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/image_userPick/image_user_pick.dart';
import 'package:nexprime/widgets/inputs/app_input_widget_tow.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import '../../../constant/app_asserts_image_path.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/app_routes_key.dart';
import '../../../widgets/buttons/app_button.dart';

class KycVerificationScreen extends ConsumerWidget {
  const KycVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(signUpProvider);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                width: AppSize.size.width * 0.8,
                height: AppSize.size.height * 0.14,
                child: Center(
                  child: AppImage(
                    width: AppSize.size.width * 0.8,
                    path: AppAssertsImagePath.instance.appLogo,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                width: AppSize.size.width * 0.8,
                child: AppText(
                  text: "KYC Verification",
                  textAlign: TextAlign.center,
                  fontFamily: AppConstant.instance.openSans,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  fontSize: AppSize.width(value: 24),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                width: AppSize.size.width * 0.8,
                child: AppText(
                  text: "Verify your identity to keep your account secure",
                  textAlign: TextAlign.center,
                  fontFamily: AppConstant.instance.openSans,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  fontSize: AppSize.width(value: 18),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: AppInputWidgetTwo(
                title: "Add Kyc file",
                maxLines: 1,
                // padding: EdgeInsets.symmetric(horizontal: 0),
                hintText: provider.kycDocument.isEmpty
                    ? "Add valid kyc file"
                    : provider.kycDocument.split('/').last,
                suffixIcon: GestureDetector(
                  onTap: () {
                    appImageUserTake(
                      callBack: (v) {
                        ref
                            .read(signUpProvider.notifier)
                            .stateUpdate(kycDocument: v);
                      },
                    );
                  },
                  child: Icon(Icons.attach_file),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.048,
                  vertical: AppSize.size.width * 0.04,
                ),
                child: AppButton(
                  onTap: () async {
                    final state = ref.read(signUpProvider);
                    if (state.kycDocument.isEmpty) {
                      return;
                    }
                    await ref.read(signUpProvider.notifier).vendorSignup();
                  },
                  title: "Submit",
                  isLoading: provider.isLoading,
                  height: AppSize.size.height * 0.06,
                  backgroundColor: AppColors.instance.green,
                  borderColor: AppColors.instance.green,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: Wrap(
                  children: [
                    AppText(
                      text: "Already have an account?",
                      fontFamily: AppConstant.instance.openSans,
                    ),
                    Gap(width: 10),
                    InkWell(
                      onTap: () {
                        AppRoutes.instance.pushNamed(
                          AppRoutesKey.instance.signInScreen,
                        );
                      },
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      child: AppText(
                        text: "Sign In",
                        fontFamily: AppConstant.instance.openSans,
                        fontWeight: FontWeight.w600,
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
