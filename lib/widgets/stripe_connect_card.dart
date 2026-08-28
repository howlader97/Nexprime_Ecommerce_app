import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:nexprime/provider/stripe_connect_provider.dart';

class StripeConnectCard extends ConsumerStatefulWidget {
  const StripeConnectCard({super.key});

  @override
  ConsumerState<StripeConnectCard> createState() => _StripeConnectCardState();
}

class _StripeConnectCardState extends ConsumerState<StripeConnectCard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(stripeConnectProvider.notifier).fetchStatus();
    });
  }

  Future<void> _handleConnect() async {
    final notifier = ref.read(stripeConnectProvider.notifier);
    final url = await notifier.getOnboardingUrl();
    if (url != null && mounted) {
      await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (context) => StripeOnboardingWebView(url: url),
        ),
      );
      if (mounted) {
        ref.read(stripeConnectProvider.notifier).fetchStatus();
      }
    }
  }

  Future<void> _handleOpenDashboard() async {
    final notifier = ref.read(stripeConnectProvider.notifier);
    final url = await notifier.getDashboardLoginUrl();
    if (url != null && mounted) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stripeConnectProvider);

    Color statusColor;
    String statusText;
    IconData statusIcon;

    final bool isConnected = state.isCompleted ||
        state.status == 'CONNECTED' ||
        state.status == 'COMPLETED' ||
        state.status == 'ACTIVE' ||
        (state.payoutsEnabled && state.status != 'PENDING');

    if (isConnected) {
      statusColor = Colors.green;
      statusText = 'Stripe Connected & Active';
      statusIcon = Icons.check_circle;
    } else if (state.status == 'PENDING') {
      statusColor = Colors.orange;
      statusText = 'Action Needed (Onboarding Pending)';
      statusIcon = Icons.warning_amber_rounded;
    } else {
      statusColor = Colors.grey;
      statusText = 'Not Connected';
      statusIcon = Icons.link_off;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance, color: AppColors.instance.green, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Bank Payouts & Stripe Connect',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: () {
                    ref.read(stripeConnectProvider.notifier).fetchStatus();
                  },
                )
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Link your bank account with Stripe Express to receive direct payout earnings for completed orders.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            if (state.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (isConnected) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleOpenDashboard,
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: const Text('View Stripe Payout Dashboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleConnect,
                  icon: const Icon(Icons.link, size: 18),
                  label: Text(
                    state.status == 'PENDING' ? 'Complete Stripe Onboarding' : 'Connect Stripe Account',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class StripeOnboardingWebView extends ConsumerStatefulWidget {
  final String url;
  const StripeOnboardingWebView({super.key, required this.url});

  @override
  ConsumerState<StripeOnboardingWebView> createState() =>
      _StripeOnboardingWebViewState();
}

class _StripeOnboardingWebViewState
    extends ConsumerState<StripeOnboardingWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _handledReturn = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
            _checkReturnUrl(url);
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            _checkReturnUrl(url);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (_checkReturnUrl(request.url)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  bool _checkReturnUrl(String url) {
    if (_handledReturn) return true;
    if (url.contains('/vendor/stripe/success') ||
        url.contains('/vendor/stripe/status') ||
        url.contains('stripe-callback')) {
      _handledReturn = true;
      ref.read(stripeConnectProvider.notifier).fetchStatus();
      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Stripe Account Connected Successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Express Onboarding'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(stripeConnectProvider.notifier).fetchStatus();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
