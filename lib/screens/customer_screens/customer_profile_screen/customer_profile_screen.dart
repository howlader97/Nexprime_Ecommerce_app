import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/screens/customer_screens/customer_profile_screen/provider/customer_profile_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_profile_screen/widgets/customer_profile_view_loader_widget.dart';
import 'package:nexprime/screens/customer_screens/customer_profile_screen/widgets/customer_profile_view_widget.dart';
import 'package:nexprime/services/storage/storage_services.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:nexprime/widgets/loading/app_loader.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerProfileScreen extends ConsumerStatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  ConsumerState<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
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
      // AppRoutes.instance.go(AppRoutesKey.instance.signInScreen);
    } catch (e) {
      errorLog("error is", e);
    } finally {
      AppLoader().hide();
    }
  }

  @override
  void initState() {
    super.initState();
    onAppInitial();
  }

  Future<void> openSupportEmail() async {
    final Uri emailUri = Uri.parse('mailto:nexprime1821@gmail.com?subject=Support Request&body=Hello, I need help...');
    await launchUrl(emailUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(customerProfileProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.read(customerProfileProvider.notifier).refreshProfile();
          },
          child: profile.when(
            data: (profileData) {
              if (isGuest) {
                return CustomerProfileViewWidget(isGuest: isGuest, login: login, logout: logout, openSupportEmail: openSupportEmail, profile: null);
              } else if (profileData == null) {
                return CustomerProfileViewWidget(isGuest: isGuest, login: login, logout: logout, openSupportEmail: openSupportEmail, profile: null);
              } else {
                return CustomerProfileViewWidget(
                  isGuest: isGuest,
                  login: login,
                  logout: logout,
                  openSupportEmail: openSupportEmail,
                  profile: profileData,
                );
              }
            },
            loading: () => CustomerProfileViewLoaderWidget(),
            error: (error, stackTrace) =>
                CustomerProfileViewWidget(isGuest: isGuest, login: login, logout: logout, openSupportEmail: openSupportEmail, profile: null),
          ),
        ),
      ),
    );
  }
}
