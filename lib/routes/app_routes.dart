import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/models/product_model.dart' as pm;
import 'package:nexprime/models/marketing_product_model.dart';
import 'package:nexprime/routes/internet_check_provider.dart';
import 'package:nexprime/screens/app_navigation_screen/app_navigation_screen.dart';
import 'package:nexprime/screens/auth_screen/forgot_screen/forgot_screen.dart';
import 'package:nexprime/screens/auth_screen/kyc_verification_screen/kyc_verification_screen.dart';
import 'package:nexprime/screens/auth_screen/on_board_screen/on_board_screen.dart';
import 'package:nexprime/screens/auth_screen/sign_in_screen/sign_in_screen.dart';
import 'package:nexprime/screens/auth_screen/sign_up_screen/sign_up_screen.dart';
import 'package:nexprime/screens/auth_screen/sign_up_verify_screen/sign_up_verify_screen.dart';
import 'package:nexprime/screens/auth_screen/verification_in_progress_screen/verification_in_progress_screen.dart';
import 'package:nexprime/screens/base_screen/about_us_screen/about_us_screen.dart';
import 'package:nexprime/screens/base_screen/error_screen/error_screen.dart';
import 'package:nexprime/screens/base_screen/faq_screen/faq_screen.dart';
import 'package:nexprime/screens/base_screen/language_change_screen/language_change_screen.dart';
import 'package:nexprime/screens/base_screen/no_internet_screen/no_internet_screen.dart';
import 'package:nexprime/screens/base_screen/not_found_screen/not_found_screen.dart';
import 'package:nexprime/screens/base_screen/privacy_policy_screen/privacy_policy_screen.dart';
import 'package:nexprime/screens/base_screen/terms_and_conditions_screen/terms_and_conditions_screen.dart';
import 'package:nexprime/screens/customer_screens/custom_cloth_details_screen/customer_cloth_details_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_cart_screen/customer_cart_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_chat_screen/customer_chat_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_cloth_checkout_screen/customer_cloth_checkout_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_cloth_screen/customer_cloth_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_delivery_info/customer_delivery_info.dart';
import 'package:nexprime/screens/customer_screens/customer_edit_profile_screen/customer_edit_profile_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_faq_screen/customer_faq_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_follow_shop_list/customer_follow_shop_list.dart';
import 'package:nexprime/screens/customer_screens/customer_food_details_screen/customer_food_details_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_groceries_home_categories/customer_groceries_home_categories.dart';
import 'package:nexprime/screens/customer_screens/customer_marketplace/customer_marketplace_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_marketplace_product_details/customer_marketplace_product_details.dart';
import 'package:nexprime/screens/customer_screens/customer_message_screen/customer_message_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_my_product_screens/customer_my_product_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_new_product_list/customer_new_product_list.dart';
import 'package:nexprime/screens/customer_screens/customer_notification_screen/customer_notification_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_order_screen/customer_order_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_order_successful_screen/customer_order_successful_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_order_track_list/customer_order_track_list.dart';
import 'package:nexprime/screens/customer_screens/customer_payment_card/customer_payment_card.dart';
import 'package:nexprime/screens/customer_screens/customer_payment_card_details/customer_payment_card_details.dart';
import 'package:nexprime/screens/customer_screens/customer_privacy_policy/customer_privacy_policy.dart';
import 'package:nexprime/screens/customer_screens/customer_report_screen/customer_report_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_review_list_screen/customer_review_list_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_review_screen/customer_review_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_shop_screen/customer_shop_screen.dart';
import 'package:nexprime/screens/customer_screens/customer_terms_conditions/customer_terms_conditions.dart';
import 'package:nexprime/screens/customer_screens/customer_search_screen/customer_search_screen.dart';
import 'package:nexprime/screens/splash_screen/splash_screen.dart';
import 'package:nexprime/screens/vendor_screens/vendor_edit_profile_screen/vendor_edit_profile_screen.dart';
import 'package:nexprime/screens/vendor_screens/vendor_home_screen/vendor_home_screen.dart';
import 'package:nexprime/screens/vendor_screens/vendor_live_screen/vendor_live_screen.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  ////////////// constructor
  AppRoutes._privateConstructor();
  static final AppRoutes _instance = AppRoutes._privateConstructor();
  static AppRoutes get instance => _instance;
  //////////////// routes

  GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    initialLocation: AppRoutesKey.instance.initial,
    routes: [
      GoRoute(
        path: AppRoutesKey.instance.initial,
        name: AppRoutesKey.instance.splash,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.onBoardScreen}",
        name: AppRoutesKey.instance.onBoardScreen,
        builder: (context, state) => OnBoardScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.forgotScreen}",
        name: AppRoutesKey.instance.forgotScreen,
        builder: (context, state) => ForgotScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.signInScreen}",
        name: AppRoutesKey.instance.signInScreen,
        builder: (context, state) => SignInScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.signUpScreen}",
        name: AppRoutesKey.instance.signUpScreen,
        builder: (context, state) => SignUpScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.appNavigationScreen}",
        name: AppRoutesKey.instance.appNavigationScreen,
        builder: (context, state) => AppNavigationScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.signUpVerifyScreen}",
        name: AppRoutesKey.instance.signUpVerifyScreen,
        builder: (context, state) => SignUpVerifyScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.notFoundScreen}",
        name: AppRoutesKey.instance.notFoundScreen,
        builder: (context, state) => NotFoundScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.errorScreen}",
        name: AppRoutesKey.instance.errorScreen,
        builder: (context, state) => ErrorScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.noInternetScreen}",
        name: AppRoutesKey.instance.noInternetScreen,
        builder: (context, state) => NoInternetScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.faqScreen}",
        name: AppRoutesKey.instance.faqScreen,
        builder: (context, state) => FaqScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.privacyPolicyScreen}",
        name: AppRoutesKey.instance.privacyPolicyScreen,
        builder: (context, state) => PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.termsAndConditionScreen}",
        name: AppRoutesKey.instance.termsAndConditionScreen,
        builder: (context, state) => TermsAndConditionsScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.vendorEditProfileScreen}",
        name: AppRoutesKey.instance.vendorEditProfileScreen,
        builder: (context, state) => VendorEditProfileScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerMarketplaceProductDetails}",
        name: AppRoutesKey.instance.customerMarketplaceProductDetails,
        builder: (context, state) {
          final productId = state.extra as int? ?? 0;
          return CustomerMarketplaceProductDetails(productId: productId);
        },
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.aboutUsScreen}",
        name: AppRoutesKey.instance.aboutUsScreen,
        builder: (context, state) => AboutUsScreen(),
      ),
            GoRoute(
        path: "/${AppRoutesKey.instance.changeLanguageScreen}",
        name: AppRoutesKey.instance.changeLanguageScreen,
        builder: (context, state) => LanguageChangeScreen(),
      ),
      GoRoute(
        path:
            "/${AppRoutesKey.instance.customerGroceriesHomeCategories}/:id/:name",
        name: AppRoutesKey.instance.customerGroceriesHomeCategories,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          final name = state.pathParameters['name'] ?? '';
          return CustomerGroceriesHomeCategories(
            countryId: id,
            countryName: name,
          );
        },
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerClothScreen}/:id/:name",
        name: AppRoutesKey.instance.customerClothScreen,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          final name = state.pathParameters['name'] ?? '';
          return CustomerClothScreen(countryId: id, categoryName: name);
        },
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerClothDetailsScreen}",
        name: AppRoutesKey.instance.customerClothDetailsScreen,
        builder: (context, state) {
          final product = state.extra as pm.ProductModel?;
          if (product == null) {
            final dummyProduct = pm.ProductModel(
              id: 0,
              name: "Dummy Huddie",
              description:
                  "A premium huddie for testing when no data is provided.",
              basePrice: 0.0,
              stockUnits: 20,
              size: ["S", "M", "L", "XL"],
              colors: ["#8b302c", "#222222", "#dfa88d"],
              isDiscountSale: false,
              salePrice: 45.00,
              discountPercentage: 0.0,
              shippingResponsibility: "",
              shippingCharge: 0.0,
              totalPayableAmount: 45.00,
              images: [
                'https://media.istockphoto.com/id/1496615445/photo/portrait-of-beautiful-happy-woman-smiling-during-sunset-outdoor.jpg?s=2048x2048&w=is&k=20&c=G4K8PJ5h68gMohGhyuZ1UJ9w9103R9L64Z7_8pjhKlU=',
                'https://img.freepik.com/free-photo/young-woman-wearing-maroon-hoodie_23-2148767357.jpg?t=st=1740023447~exp=1740027047~hmac=6b93f7e5f9f6e56e0e56e0e56e0e56e0e56e0e56e0e56e0e56e0e56e0e56e0e5&w=740',
              ],
              storeId: 0,
              store: pm.Store(
                id: 0,
                name: 'Generic Store',
                address: '',
                photo: '',
              ),
              categories: [pm.Category(id: 0, name: 'Clothing', image: '')],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            return CustomerClothDetailsScreen(product: dummyProduct);
          }
          return CustomerClothDetailsScreen(product: product);
        },
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerClothCheckoutScreen}",
        name: AppRoutesKey.instance.customerClothCheckoutScreen,
        builder: (context, state) => CustomerClothCheckoutScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerDeliveryInfo}",
        name: AppRoutesKey.instance.customerDeliveryInfo,
        builder: (context, state) => CustomerDeliveryInfo(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerPaymentCard}",
        name: AppRoutesKey.instance.customerPaymentCard,
        builder: (context, state) => CustomerPaymentCard(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerCartScreen}",
        name: AppRoutesKey.instance.customerCartScreen,
        builder: (context, state) => CustomerCartScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerPaymentCardDetails}",
        name: AppRoutesKey.instance.customerPaymentCardDetails,
        builder: (context, state) => CustomerPaymentCardDetails(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerOrderSuccessfulScreen}",
        name: AppRoutesKey.instance.customerOrderSuccessfulScreen,
        builder: (context, state) => CustomerOrderSuccessfulScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerFoodDetailsScreen}",
        name: AppRoutesKey.instance.customerFoodDetailsScreen,
        builder: (context, state) {
          final product = state.extra as pm.ProductModel?;
          if (product == null) {
            final dummyProduct = pm.ProductModel(
              id: 0,
              name: "Deluxe Sushi & ashimi Platter",
              description:
                  "A premium selection of fresh Atlantic salmon, tuna, and yellowtail sashimi, paired with our signature dragon rolls and nigiri. Served with authentic pickled ginger, wasabi, and premium soy sauce. Perfect for sharing.",
              basePrice: 0.0,
              stockUnits: 20,
              size: [],
              colors: [],
              isDiscountSale: false,
              salePrice: 199.99,
              discountPercentage: 0.0,
              shippingResponsibility: "",
              shippingCharge: 0.0,
              totalPayableAmount: 0.0,
              images: [
                "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=800&q=80",
                "https://images.unsplash.com/photo-1553621042-f6e147245754?auto=format&fit=crop&w=800&q=80",
                "https://images.unsplash.com/photo-1583623025817-d180a2221d0a?auto=format&fit=crop&w=800&q=80",
              ],
              storeId: 0,
              store: pm.Store(
                id: 0,
                name: 'Green Thumb',
                address: '',
                photo: '',
              ),
              categories: [
                pm.Category(id: 0, name: 'Home appliance', image: ''),
              ],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            return CustomerFoodDetailsScreen(product: dummyProduct);
          }
          return CustomerFoodDetailsScreen(product: product);
        },
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerOrderTrackList}",
        name: AppRoutesKey.instance.customerOrderTrackList,
        builder: (context, state) {
          final trackingUrl = state.extra as String? ?? '';
          return CustomerOrderTrackList(trackingUrl: trackingUrl);
        },
      ),
      GoRoute(
          path: "/${AppRoutesKey.instance.customerReviewScreen}",
          name: AppRoutesKey.instance.customerReviewScreen,
          builder: (context, state) {
            final orderId = state.extra as int? ?? 0;
            return CustomerReviewScreen(orderId: orderId);
          }
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerFollowShopList}",
        name: AppRoutesKey.instance.customerFollowShopList,
        builder: (context, state) => CustomerFollowShopList(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerMyProductScreen}",
        name: AppRoutesKey.instance.customerMyProductScreen,
        builder: (context, state) => CustomerMyProductScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerNewProductList}",
        name: AppRoutesKey.instance.customerNewProductList,
        builder: (context, state) {
          final product = state.extra as MarketingProductModel?;
          return CustomerNewProductList(product: product);
        },
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerMarketplaceScreen}",
        name: AppRoutesKey.instance.customerMarketplaceScreen,
        builder: (context, state) => CustomerMarketplaceScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerMessageScreen}",
        name: AppRoutesKey.instance.customerMessageScreen,
        builder: (context, state) => CustomerMessageScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerChatScreen}",
        name: AppRoutesKey.instance.customerChatScreen,
        builder: (context, state) {

          var args =  state.extra;
          if(args is Map){
            var userId = int.tryParse("${args['userId'] ?? 0}") ?? 0;
            var userName = "${args['name'] ?? ""}";
            var profileImageUrl = "${args['profileImageUrl'] ?? ''}";
            MarketingProductModel? product = args["product"] is MarketingProductModel ? args["product"] : null;
            bool showReport=args['showReport'] == true;

            return CustomerChatScreen(
              name: userName,
              profileImageUrl: profileImageUrl,
              product: product,
              userId: userId,
              showReport: showReport,
            );
          }
          return NotFoundScreen();

        },
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerReportScreen}",
        name: AppRoutesKey.instance.customerReportScreen,
        builder: (context, state) => CustomerReportScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerPrivacyPolicy}",
        name: AppRoutesKey.instance.customerPrivacyPolicy,
        builder: (context, state) => CustomerPrivacyPolicy(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerTermsConditions}",
        name: AppRoutesKey.instance.customerTermsConditions,
        builder: (context, state) => CustomerTermsConditions(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerOrderScreen}",
        name: AppRoutesKey.instance.customerOrderScreen,
        builder: (context, state) => CustomerOrderScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerReviewListScreen}",
        name: AppRoutesKey.instance.customerReviewListScreen,
        builder: (context, state) {
          final productId = state.extra as int? ?? 0;
          return CustomerReviewListScreen(productId: productId);
        },
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerEditProfileScreen}",
        name: AppRoutesKey.instance.customerEditProfileScreen,
        builder: (context, state) => CustomerEditProfileScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerFaqScreen}",
        name: AppRoutesKey.instance.customerFaqScreen,
        builder: (context, state) => CustomerFaqScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.vendorHomeScreen}",
        name: AppRoutesKey.instance.vendorHomeScreen,
        builder: (context, state) => VendorHomeScreen(),
      ),

      GoRoute(
        path: "/${AppRoutesKey.instance.customerShopScreen}",
        name: AppRoutesKey.instance.customerShopScreen,
        builder: (context, state) {
          var id = state.extra;
          if (id is String) {
            return CustomerShopScreen(storeId: id);
          }

          return NotFoundScreen();
        },
      ),

      GoRoute(
        path: "/${AppRoutesKey.instance.customerSearchScreen}",
        name: AppRoutesKey.instance.customerSearchScreen,
        builder: (context, state) {
          final query = state.uri.queryParameters['q'] ?? '';
          return CustomerSearchScreen(query: query);
        },
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.customerNotificationScreen}",
        name: AppRoutesKey.instance.customerNotificationScreen,
        builder: (context, state) => CustomerNotificationScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.kycVerificationScreen}",
        name: AppRoutesKey.instance.kycVerificationScreen,
        builder: (context, state) => KycVerificationScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.verificationInProgressScreen}",
        name: AppRoutesKey.instance.verificationInProgressScreen,
        builder: (context, state) => VerificationInProgressScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.vendorLiveScreen}",
        name: AppRoutesKey.instance.vendorLiveScreen,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final token = extra['token'] as String;
          final streamId = extra['streamId'] as int;
          final isHost = extra['isHost'] as bool? ?? true;
          final shopName = extra['shopName'] as String? ?? 'Shop';
          final shopPhoto = extra['shopPhoto'] as String? ?? '';
          final offer = extra['offer'] as String? ?? '';

          return VendorLiveScreen(
            token: token,
            streamId: streamId,
            isHost: isHost,
            shopName: shopName,
            shopPhoto: shopPhoto,
            offer: offer,
          );
        },
      ),
    ],
    errorBuilder: (context, state) {
      return NotFoundScreen();
    },
    redirect: (context, state) {
      final container = ProviderScope.containerOf(context, listen: false);
      final asyncStatus = container.read(internetStatusProvider);

      if (asyncStatus.isLoading) return null;
      if (asyncStatus.hasError) return "/${AppRoutesKey.instance.errorScreen}";

      final isOnline = asyncStatus.value ?? true;
      final goingToNoInternet =
          state.name == AppRoutesKey.instance.noInternetScreen;

      if (!isOnline && !goingToNoInternet) {
        return "/${AppRoutesKey.instance.noInternetScreen}";
      }

      if (isOnline && goingToNoInternet) {
        return "/"; // initial route
      }

      return null;
    },
  );

  ////////////////////. route operation start
  String _normalize(String value) => value.startsWith("/") ? value : "/$value";

  void go(String value) {
    try {
      router.go(_normalize(value));
    } catch (e) {
      errorLog("goNamed", e);
    }
  }

  void goNamed(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
    String? fragment,
  }) {
    try {
      router.goNamed(
        value,
        pathParameters: pathParameters,
        extra: extra,
        fragment: fragment,
        queryParameters: queryParameters,
      );
    } catch (e) {
      errorLog("goNamed", e);
    }
  }

  void replace(String value, {Object? extra}) {
    try {
      router.replace(_normalize(value), extra: extra);
    } catch (e) {
      errorLog("replaceNamed", e);
    }
  }

  void replaceNamed(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      router.replaceNamed(
        value,
        pathParameters: pathParameters,
        extra: extra,
        queryParameters: queryParameters,
      );
    } catch (e) {
      errorLog("replaceNamed", e);
    }
  }

  Future<T?> push<T>(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      return router.push<T>(_normalize(value), extra: extra);
    } catch (e) {
      errorLog("push", e);
      return Future.value(null);
    }
  }

  Future<T?> pushNamed<T>(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      return router.pushNamed<T>(
        value,
        pathParameters: pathParameters,
        extra: extra,
        queryParameters: queryParameters,
      );
    } catch (e) {
      errorLog("pushNamed", e);
      return Future.value(null);
    }
  }

  Future<T?> pushReplacement<T>(String value, {Object? extra}) {
    try {
      return router.pushReplacement<T>(_normalize(value), extra: extra);
    } catch (e) {
      errorLog("pushReplacement", e);
      return Future.value(null);
    }
  }

  Future<T?> pushReplacementNamed<T>(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      return router.pushReplacementNamed<T>(
        value,
        pathParameters: pathParameters,
        extra: extra,
        queryParameters: queryParameters,
      );
    } catch (e) {
      errorLog("pushReplacementNamed", e);
      return Future.value(null);
    }
  }

  void pop() {
    try {
      var context = rootNavigatorKey.currentContext;
      if (context == null) return;
      var doIt = GoRouter.of(context).canPop();
      if (doIt) {
        GoRouter.of(context).pop();
      }
    } catch (e) {
      errorLog("pop", e);
    }
  }

  ////////////////////. route operation end
}
