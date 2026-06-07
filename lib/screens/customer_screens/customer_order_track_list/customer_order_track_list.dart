import 'package:flutter/material.dart';
import 'package:nexprime/widgets/buttons/icon_button_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../constant/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_size.dart';
import '../../../utils/gap.dart';
import '../../../widgets/texts/app_text.dart';

class CustomerOrderTrackList extends StatefulWidget {
  final String trackingUrl;

  const CustomerOrderTrackList({super.key, required this.trackingUrl});

  @override
  State<CustomerOrderTrackList> createState() => _CustomerOrderTrackListState();
}

class _CustomerOrderTrackListState extends State<CustomerOrderTrackList> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final bool isValidUrl = widget.trackingUrl.isNotEmpty &&
        (widget.trackingUrl.startsWith('http://') || widget.trackingUrl.startsWith('https://'));

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
          //  print("WebView Page started loading: $url");
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
          //  print("WebView Page finished loading: $url");
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
          //  print("WebView Web Resource Error: ${error.description}, type: ${error.errorType}");
            if (mounted) setState(() => _isLoading = false);
          },
        ),
      );

    if (isValidUrl) {
      _controller.loadRequest(Uri.parse(widget.trackingUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
  //  print("tracking url: ${widget.trackingUrl}");
    final bool isValidUrl = widget.trackingUrl.isNotEmpty &&
        (widget.trackingUrl.startsWith('http://') || widget.trackingUrl.startsWith('https://'));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // AppBar section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.size.width * 0.04,
                vertical: AppSize.size.height * 0.01,
              ),
              child: Row(
                children: [
                  IconButtonWidget(
                    onTap: () {
                      AppRoutes.instance.pop();
                    },
                    icon: Icons.arrow_back,
                  ),
                  Gap(width: AppSize.size.width * 0.02),
                  AppText(
                    text: 'Track Order',
                    fontSize: AppSize.size.width * 0.055,
                    color: AppColors.instance.black06,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),

            // WebView or Placeholder section
            Expanded(
              child: !isValidUrl
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        size: 64,
                        color: AppColors.instance.gray400,
                      ),
                      const Gap(height: 16),
                      AppText(
                        text: 'Tracking URL is not available.',
                        fontSize: 16,
                        color: AppColors.instance.gray400,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              )
                  : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: WebViewWidget(controller: _controller),
                  ),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
