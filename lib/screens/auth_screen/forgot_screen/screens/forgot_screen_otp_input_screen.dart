import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/screens/auth_screen/forgot_screen/screens/provider/forgot_verify_email_provider.dart';
import 'package:nexprime/constant/app_asserts_image_path.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/constant/app_constant.dart';
import 'package:nexprime/screens/auth_screen/forgot_screen/screens/provider/otp_countdown_provider.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/inputs/app_input_widget_tow.dart';
import 'package:nexprime/widgets/inputs/formatter/otp_number_formatter.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

class ForgotScreenOtpInputScreen extends StatelessWidget {
  const ForgotScreenOtpInputScreen({super.key, required this.onChange, required this.formKey, required this.otpTextEditingController});
  final void Function(int index) onChange;
  final GlobalKey<FormState> formKey;
  final TextEditingController otpTextEditingController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSize.size.width,
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                width: AppSize.size.width * 0.8,
                height: AppSize.size.height * 0.14,
                child: Center(
                  child: AppImage(width: AppSize.size.width * 0.8, path: AppAssertsImagePath.instance.appLogo),
                ),
              ),

              SizedBox(
                width: AppSize.size.width * 0.8,
                child: AppText(
                  text: "Enter Verification Code",
                  textAlign: TextAlign.center,
                  fontFamily: AppConstant.instance.openSans,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  fontSize: AppSize.width(value: 18),
                ),
              ),
              AppInputWidgetTwo(
                title: "Code ",
                keyboardType: TextInputType.numberWithOptions(),
                controller: otpTextEditingController,
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.center,
                inputFormatters: [OtpNumberFormatter()],
              ),
              Gap(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppText(text: "If you didn't receive a code,", fontFamily: AppConstant.instance.openSans),
                  Consumer(
                    builder: (context, ref, child) {
                      var provider = ref.watch(otpCountdownProvider);
                      final minutes = (provider ~/ 60).toString();
                      final remainSeconds = (provider % 60).toString().padLeft(2, '0');
                      final canResend = provider == 0;
                      return canResend
                          ? Padding(
                              padding: EdgeInsets.only(right: AppSize.width(value: 20)),
                              child: InkWell(
                                onTap: () {
                                  ref.read(forgotVerifyEmailProvider.notifier).resendOtp();
                                  ref.read(otpCountdownProvider.notifier).start();
                                },
                                overlayColor: WidgetStatePropertyAll(Colors.transparent),
                                child: AppText(text: " Resend", fontFamily: AppConstant.instance.openSans, fontWeight: FontWeight.w700),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(right: AppSize.width(value: 20)),
                              child: AppText(
                                text: " Resend in $minutes:$remainSeconds s",
                                isDynamic: false,
                                fontFamily: AppConstant.instance.openSans,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                    },
                  ),
                ],
              ),
              Gap(height: 25),
              Consumer(
                builder: (context, ref, child) {
                  final isLoading = ref.watch(forgotVerifyEmailProvider);
                  return AppButton(
                    onTap: () {
                      ref
                          .read(forgotVerifyEmailProvider.notifier)
                          .verifyEmail(formKey: formKey, otpController: otpTextEditingController, onChange: onChange);
                    },
                    isLoading: isLoading,
                    backgroundColor: AppColors.instance.green,
                    borderColor: AppColors.instance.green,
                    title: "Verify",
                    margin: EdgeInsetsDirectional.symmetric(horizontal: AppSize.width(value: 20)),
                    padding: EdgeInsets.all(AppSize.width(value: 8)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
