import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/services/storage/storage_services.dart';
import 'provider/forgot_password_provider.dart';
import 'package:nexprime/constant/app_asserts_image_path.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/constant/app_constant.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/inputs/app_input_widget_tow.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

class ForgotScreenEmailInputScreen extends ConsumerWidget {
  const ForgotScreenEmailInputScreen({
    super.key,
    required this.emailTextEditingController,
    required this.onChange,
    required this.formKey,
  });
  final void Function(int index) onChange;
  final TextEditingController emailTextEditingController;
  final GlobalKey<FormState> formKey;

  void checkCallSend(WidgetRef ref) async {
    try {
      if (formKey.currentState!.validate()) {
        final email = emailTextEditingController.text.trim();
        final success = await ref
            .read(forgotPasswordProvider.notifier)
            .forgotPassword(email: email);
        if (success) {
          await StorageServices.instance.setEmail(email);
          onChange(1);
        }
      }
    } catch (e) {
      errorLog("checkCallSend", e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(forgotPasswordProvider);
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
                  child: AppImage(
                    width: AppSize.size.width * 0.8,
                    path: AppAssertsImagePath.instance.appLogo,
                  ),
                ),
              ),

              SizedBox(
                width: AppSize.size.width * 0.8,
                child: AppText(
                  text: "Enter Email Address",
                  textAlign: TextAlign.center,
                  fontFamily: AppConstant.instance.openSans,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  fontSize: AppSize.width(value: 18),
                ),
              ),
              AppInputWidgetTwo(
                title: "Email",
                isEmail: true,
                keyboardType: TextInputType.emailAddress,
                controller: emailTextEditingController,
                textInputAction: TextInputAction.next,
              ),
              Gap(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: AppSize.width(value: 20)),
                  child: InkWell(
                    onTap: () {
                      AppRoutes.instance.pop();
                    },
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    child: AppText(
                      text: "Back to sign in",
                      fontFamily: AppConstant.instance.openSans,
                    ),
                  ),
                ),
              ),
              Gap(height: 25),
              AppButton(
                onTap: () => checkCallSend(ref),
                isLoading: isLoading,
                backgroundColor: AppColors.instance.green,
                borderColor: AppColors.instance.green,
                title: "Send",
                margin: EdgeInsetsDirectional.symmetric(
                  horizontal: AppSize.width(value: 20),
                ),
                padding: EdgeInsets.all(AppSize.width(value: 8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
