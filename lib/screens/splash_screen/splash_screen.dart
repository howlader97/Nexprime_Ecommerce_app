import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_asserts_image_path.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/services/storage/storage_services.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  StorageServices storageServices = StorageServices.instance;

  Future<void> onAppInitial() async {
    try {
      var firstTime = await storageServices.getAppFirstTime();
      if (firstTime) {
        AppRoutes.instance.go(AppRoutesKey.instance.onBoardScreen);
        return;
      }
      var token = await storageServices.getToken();
      if (token.isEmpty) {
        AppRoutes.instance.go(AppRoutesKey.instance.signInScreen);
      } else {
        AppRoutes.instance.go(AppRoutesKey.instance.appNavigationScreen);
      }
    } catch (e) {
      errorLog("onAppInitial", e);
    }
  }

  @override
  void initState() {
    super.initState();
    onAppInitial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: Center(
        child: AppImage(path: AppAssertsImagePath.instance.logo, width: AppSize.size.width * 0.35),
      ),
    );
  }
}
