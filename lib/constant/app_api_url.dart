import 'package:flutter/foundation.dart';
import 'package:nexprime/utils/app_log.dart';

class AppApiUrl {
  AppApiUrl._privateConstructor();
  static final AppApiUrl _instance = AppApiUrl._privateConstructor();
  static AppApiUrl get instance => _instance;
  //////////////  app base api end point
  static final String domain = _getDomain();
  static final String socket = _getDomain();
  final String baseUrl = domain;

  //////////////////////////////////  base
  String refreshToken = "/refreshToken";
  String about = "/rule/about";
  String privacyPolicy = "/rule/privacy-policy";
  String termsAndConditions = "/rule/terms-and-conditions";
  String faq = "/faq";
  String notification = "/notification";
  String faqs = "/faqs";
  String staticPages = "/static-pages";
  ////////////
  String login = "/auth/login";
  String user = "n";
  String banners = "/banners";
  String customerProfile = "/auth/profile";
  String updateProfile = "/customers/me";
  String authDeleteAccount = "/authDeleteAccount";
  String customerSignUp = "/auth/signup";
  String vendorSignUp = "/auth/vendor/signup";
  String changePassword = "/changePassword";
  String userResendOtp = "/auth/resend-otp";
  String authOtpVerify = "/auth/verify-otp";
  String authForgotPassword = "/auth/forgot-password";
  String authVerifyEmail = "/auth/verify-forgot-password";
  String authResetPassword = "/auth/reset-password";
  String discountProduct = "/products/highest-discount";
  String stores = "/stores";
  String deliveryInfo = "/orders/delivery-address";
  String createOrder = "/orders";
  String createPaymentIntent(int orderId) =>
      "/orders/$orderId/create-payment-intent";
  String viewShop(int id) => "/stores/$id";
  String review(int productId) => "/orders/product/$productId/ratings";
  String marketingProducts = "/marketing-products";
  String marketingProductById(int id) => "/marketing-products/$id";
  String deleteMarketingProduct(int id) => "/marketing-products/$id";
  String updateMarketingProduct(int id) => "/marketing-products/$id";
  String myMarketingProducts = "/marketing-products/my";
  String publishingFee = "/admin/marketing-settings";
  String groceriesCountry(String countryId) =>
      "/categories/$countryId/subcategories";
  String filterProducts(int id, {int? shopId, int? categoryId, String? size}) {
    String url = "/products/filter?subcategory_ids=$id";
    if (shopId != null) {
      url += "&shop_id=$shopId";
    }
    if (categoryId != null) {
      url += "&subcategory_ids=$categoryId";
    }
    if (size != null && size.isNotEmpty) {
      url += "&size=$size";
    }
    return url;
  }
  String filterProductsByShopAndSubcategory({required int shopId, required int subcategoryIds}) {
    return "/products/filter?shop_id=$shopId&subcategory_ids=$subcategoryIds";
  }
  String addToCart = "/cart";
  String cartQuantity(int itemId) => "/cart/$itemId";
  String storeFollowerCount(int storeId) => "/stores/$storeId/follower-count";
  String searchProducts(String query) => "/products/search?q=$query";
  String myOrder ="/orders/me";
  String orderRatings(int id) => "/orders/$id/ratings";

  //vendor
  String vendorDashboard = "/vendor/dashboard/stats";
  String vendorStoreMe = "/vendor/store/me";
  String followStores = "/stores/followed";
  String followStore(int id) => "/stores/$id/follow";
  String liveStream = "/live-streams";
  String uploadImage = "/upload/image";
  String report = "/reports";
  String stopStream(int id) => "/live-streams/$id/stop";
  String streamNotification = "/live-streams/followed";
  String joinStream(int id) => "/live-streams/$id/join";
  String vendorProducts = "/vendor/products";
  String vendorOrdersMe = "/orders/vendor/me";

  String archiveSubOrder(int id) => "/orders/sub-order/$id/archive";
  String completeSubOrder(int id) => "/orders/sub-order/$id/complete";
  String fulfillSubOrder(int id) => "/orders/sub-order/$id/fulfill";
}

String _getDomain() {
  const String liveServer = "https://api.nexprimeapp.com";
  const String localServer = "https://api.nexprimeapp.com";

  try {
    if (kDebugMode) {
      return localServer;
    }
  } catch (e) {
    errorLog("_getDomain", e);
  }
  return liveServer;
}
