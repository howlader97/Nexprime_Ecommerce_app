import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/services/api/stripe_connect_service.dart';

class StripeConnectState {
  final bool isLoading;
  final bool isCompleted;
  final bool payoutsEnabled;
  final String status;
  final String? stripeAccountId;
  final String? errorMessage;

  StripeConnectState({
    this.isLoading = false,
    this.isCompleted = false,
    this.payoutsEnabled = false,
    this.status = 'NOT_CONNECTED',
    this.stripeAccountId,
    this.errorMessage,
  });

  StripeConnectState copyWith({
    bool? isLoading,
    bool? isCompleted,
    bool? payoutsEnabled,
    String? status,
    String? stripeAccountId,
    String? errorMessage,
  }) {
    return StripeConnectState(
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
      payoutsEnabled: payoutsEnabled ?? this.payoutsEnabled,
      status: status ?? this.status,
      stripeAccountId: stripeAccountId ?? this.stripeAccountId,
      errorMessage: errorMessage,
    );
  }
}

class StripeConnectNotifier extends Notifier<StripeConnectState> {
  @override
  StripeConnectState build() {
    return StripeConnectState();
  }

  final StripeConnectService _service = StripeConnectService.instance;

  Future<void> fetchStatus() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final data = await _service.getAccountStatus();
    if (data != null) {
      state = state.copyWith(
        isLoading: false,
        status: data['status'] ?? 'NOT_CONNECTED',
        isCompleted: data['isCompleted'] ?? false,
        payoutsEnabled: data['payoutsEnabled'] ?? false,
        stripeAccountId: data['stripeAccountId'],
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch Stripe status.',
      );
    }
  }

  Future<String?> getOnboardingUrl() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final url = await _service.getOnboardingUrl();
    state = state.copyWith(isLoading: false);
    return url;
  }

  Future<String?> getDashboardLoginUrl() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final url = await _service.getLoginUrl();
    state = state.copyWith(isLoading: false);
    return url;
  }
}

final stripeConnectProvider =
    NotifierProvider<StripeConnectNotifier, StripeConnectState>(
  StripeConnectNotifier.new,
);
