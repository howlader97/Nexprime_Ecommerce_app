import 'package:flutter/material.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/widgets/buttons/custom_decorated_box.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../../constant/app_asserts_icons_path.dart';
import '../../../constant/app_colors.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/buttons/app_button.dart';

class VerificationInProgressScreen extends StatelessWidget {
  const VerificationInProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: AppImage(
                  width: AppSize.size.width * 0.3,
                  path: AppAssertsIconsPath.instance.vpIcon,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: AppText(
                  text: "Verification in Progress",
                  fontWeight: FontWeight.w600,
                  fontSize: AppSize.size.width * 0.06,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.size.width * 0.1,
                  ),
                  child: AppText(
                    text:
                        "We will send you an  approval email once your application is approved it might take a week.",
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                    fontSize: AppSize.size.width * 0.04,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CustomDecoratedBox(
                padding: EdgeInsets.all(AppSize.size.width * 0.05),
                color: Color(0xFFB9DFBE).withAlpha(90),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSize.size.width * 0.04,
                  ),
                  child: AppText(
                    text: "Thank you for your patience.",
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w600,
                    fontSize: AppSize.width(value: 32),
                    color: Color(0xFF469750),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.04,
                  vertical: AppSize.size.width * 0.04,
                ),
                child: AppButton(
                  onTap: () {
                    AppRoutes.instance.go(
                      AppRoutesKey.instance.signInScreen,
                    );
                  },
                  title: "Back To Login",
                  height: AppSize.size.height * 0.06,
                  backgroundColor: AppColors.instance.green,
                  borderColor: AppColors.instance.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
