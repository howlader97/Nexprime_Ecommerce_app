import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/provider/nav_provider.dart';

import 'package:nexprime/screens/base_screen/error_screen/error_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_cart_screen/customer_cart_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/customer_home_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_order_screen/customer_order_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_profile_screen/customer_profile_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_search_screen/customer_search_screen.dart';
import 'package:nexprime/screens/vendor_screens/vendor_home_screen/vendor_home_screen.dart';
import 'package:nexprime/screens/vendor_screens/vendor_order_screen/vendor_order_screen.dart';
import 'package:nexprime/screens/vendor_screens/vendor_product_screen/vendor_product_screen.dart';
import 'package:nexprime/services/storage/storage_services.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/widgets/dialogs/login_popUP.dart';

import '../vendor_screens/vendor_profile_screen/vendor_profile_screen.dart';
import '../vendor_screens/vendor_streaming_screen/vendor_stemming_screen.dart';

class AppNavigationScreen extends ConsumerStatefulWidget {
  const AppNavigationScreen({super.key});

  @override
  ConsumerState<AppNavigationScreen> createState() =>
      _AppNavigationScreenState();
}

class _AppNavigationScreenState extends ConsumerState<AppNavigationScreen> {
  bool isLoading = true;
  StorageServices storageServices = StorageServices.instance;
  // removed local selectedIndex
  List<Widget> bodyWidget = [ErrorScreen()];
  List<BottomNavigationBarItem> bottomNavigation = [];
  void changeNavigation(int index) async{
    try {
      if (!context.mounted) return;
      var role = await storageServices.getAppRoll();
      if (role.toLowerCase() == "GUEST".toLowerCase() && (index == 2 || index == 3)){
        callLoginDialog();
        return;
      }
      ref.read(navIndexProvider.notifier).state = index;
    } catch (e) {
      errorLog("changeNavigation", e);
    }
  }

  Future<void> onAppInitial() async {
    try {
      await Future.delayed(Durations.medium1);
      var role = await storageServices.getAppRoll();
      if (role.toLowerCase() == "CUSTOMER".toLowerCase() ||role.toLowerCase() == "GUEST".toLowerCase()  ) {
        bodyWidget = [
          CustomerHomeScreen(),
          CustomerSearchScreen(),
          CustomerCartScreen(),
          CustomerOrderScreen(),
          CustomerProfileScreen(),
        ];
        bottomNavigation = [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(AppAssertsIconsPath.instance.homeIcon),
              color: Color(0xF8FCF8B8),
              size: AppSize.size.width * 0.1,
            ),
            activeIcon: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.size.width * 0.02),
              ),
              child: ImageIcon(
                AssetImage(AppAssertsIconsPath.instance.homeIcon),
                size: AppSize.size.width * 0.1,
              ),
            ),
            label: "app",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(AppAssertsIconsPath.instance.searchIcon),
              color: Color(0xF8FCF8B8),
              size: AppSize.size.width * 0.1,
            ),
            activeIcon: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.size.width * 0.02),
              ),
              child: ImageIcon(
                AssetImage(AppAssertsIconsPath.instance.searchIcon),
                size: AppSize.size.width * 0.1,
              ),
            ),
            label: "app",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(AppAssertsIconsPath.instance.cartIcon),
              color: Color(0xF8FCF8B8),
              size: AppSize.size.width * 0.1,
            ),
            activeIcon: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.size.width * 0.02),
              ),
              child: ImageIcon(
                AssetImage(AppAssertsIconsPath.instance.cartIcon),
                size: AppSize.size.width * 0.1,
              ),
            ),
            label: "app",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(AppAssertsIconsPath.instance.orderIcon),
              color: Color(0xF8FCF8B8),
              size: AppSize.size.width * 0.1,
            ),
            activeIcon: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.size.width * 0.02),
              ),
              child: ImageIcon(
                AssetImage(AppAssertsIconsPath.instance.orderIcon),
                size: AppSize.size.width * 0.1,
              ),
            ),
            label: "app",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(AppAssertsIconsPath.instance.accountIcon),
              color: const Color(0xF8FCF8B8),
              size: AppSize.size.width * 0.1,
            ),
            activeIcon: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.size.width * 0.02),
              ),
              child: ImageIcon(
                AssetImage(AppAssertsIconsPath.instance.accountIcon),
                size: AppSize.size.width * 0.1,
              ),
            ),
            label: "app",
          ),
        ];
      }
      if (role.toLowerCase() == "vendor".toLowerCase()) {
        bodyWidget = [
          VendorHomeScreen(),
          VendorProductScreen(),
          VendorStreamingScreen(),
          VendorOrderScreen(),
          VendorProfileScreen(),
        ];
        bottomNavigation = [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(AppAssertsIconsPath.instance.homeIcon),
              color: Color(0xF8FCF8B8),
              size: AppSize.size.width * 0.1,
            ),
            activeIcon: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.size.width * 0.02),
              ),
              child: ImageIcon(
                AssetImage(AppAssertsIconsPath.instance.homeIcon),
                size: AppSize.size.width * 0.1,
              ),
            ),
            label: "app",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(AppAssertsIconsPath.instance.vendorProductIcon),
              color: Color(0xF8FCF8B8),
              size: AppSize.size.width * 0.1,
            ),
            activeIcon: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.size.width * 0.02),
              ),
              child: ImageIcon(
                AssetImage(AppAssertsIconsPath.instance.vendorProductIcon),
                size: AppSize.size.width * 0.1,
              ),
            ),
            label: "app",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(AppAssertsIconsPath.instance.cameraIcon),
              color: Color(0xF8FCF8B8),
              size: AppSize.size.width * 0.1,
            ),
            activeIcon: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.size.width * 0.02),
              ),
              child: ImageIcon(
                AssetImage(AppAssertsIconsPath.instance.cameraIcon),
                size: AppSize.size.width * 0.1,
              ),
            ),
            label: "app",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(AppAssertsIconsPath.instance.orderIcon),
              color: Color(0xF8FCF8B8),
              size: AppSize.size.width * 0.1,
            ),
            activeIcon: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.size.width * 0.02),
              ),
              child: ImageIcon(
                AssetImage(AppAssertsIconsPath.instance.orderIcon),
                size: AppSize.size.width * 0.1,
              ),
            ),
            label: "app",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(AppAssertsIconsPath.instance.accountIcon),
              color: Color(0xF8FCF8B8),
              size: AppSize.size.width * 0.1,
            ),
            activeIcon: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.size.width * 0.02),
              ),
              child: ImageIcon(
                AssetImage(AppAssertsIconsPath.instance.accountIcon),
                size: AppSize.size.width * 0.1,
              ),
            ),
            label: "app",
          ),
        ];
      }
    } catch (e) {
      errorLog("onAppInitial", e);
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          isLoading = false;
        });
      });
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
      extendBody: true,
      body: isLoading
          ? Center(
              child: Transform.scale(
                scale: 1.5,
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          : IndexedStack(
              index: ref.watch(navIndexProvider),
              children: bodyWidget,
            ),
      bottomNavigationBar: isLoading || bottomNavigation.length < 2
          ? SizedBox()
          : BottomNavigationBar(
              items: bottomNavigation,
              onTap: changeNavigation,
              backgroundColor: Color(0xff4a524b),
              enableFeedback: false,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              currentIndex: ref.watch(navIndexProvider),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              useLegacyColorScheme: true,
            ),
    );
  }
}
