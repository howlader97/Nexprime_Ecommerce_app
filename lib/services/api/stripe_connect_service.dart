import 'package:nexprime/services/api/api_services.dart';

class StripeConnectService {
  StripeConnectService._privateConstructor();
  static final StripeConnectService _instance = StripeConnectService._privateConstructor();
  static StripeConnectService get instance => _instance;

  final ApiServices _api = ApiServices.instance;

  /// Fetch Stripe Connect Onboarding URL for current vendor
  Future<String?> getOnboardingUrl() async {
    final response = await _api.postServices(
      url: '/vendor/stripe/onboarding-link',
    );
    if (response != null && response['url'] != null) {
      return response['url'] as String;
    }
    return null;
  }

  /// Check current vendor's Stripe Connect status
  Future<Map<String, dynamic>?> getAccountStatus() async {
    final response = await _api.getServices(
      '/vendor/stripe/status',
    );
    if (response != null) {
      return Map<String, dynamic>.from(response);
    }
    return null;
  }

  /// Fetch Stripe Express Dashboard SSO login link
  Future<String?> getLoginUrl() async {
    final response = await _api.postServices(
      url: '/vendor/stripe/login-link',
    );
    if (response != null && response['url'] != null) {
      return response['url'] as String;
    }
    return null;
  }
}
