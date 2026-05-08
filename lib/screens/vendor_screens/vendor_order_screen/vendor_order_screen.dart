import 'package:flutter/material.dart';
import 'package:nexprime/screens/vendor_screens/vendor_customer_info/vendor_customer_info.dart';
import 'package:nexprime/screens/vendor_screens/vendor_product_screen/widgets/vendor_product_app_bar.dart';
import 'package:nexprime/screens/vendor_screens/vendor_view_archive/vendor_view_archive.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import '../../../utils/app_size.dart';
import '../../../utils/gap.dart';
import '../vendor_common_widget/vendor_custom_order_ordercard.dart';
import '../vendor_common_widget/vendor_custom_search_filter_row.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/screens/vendor_screens/vendor_order_screen/provider/vendor_order_provider.dart';

class VendorOrderScreen extends ConsumerWidget {
  const VendorOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(activeOrdersProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.read(vendorOrderNotifierProvider.notifier).refresh(),
                child: ordersAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text("Error: $err")),
                  data: (orders) {
                    return CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(child: _HeaderSection()),
                        orders.isEmpty
                            ? const SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: AppText(
                                    text: "No active orders found",
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final order = orders[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const VendorCustomerInfo(),
                                          ),
                                        );
                                      },
                                      child: VendorCustomOrderOrdercard(order: order),
                                    );
                                  },
                                  childCount: orders.length,
                                ),
                              ),
                      ],
                    );
                  },
                ),
              ),
            ),
            
            /// FIXED BOTTOM BUTTON
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VendorViewArchive(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const AppText( text: 
                    "View archive",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------- HEADER SECTION -------------------
class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.size.width * 0.05,
        vertical: AppSize.size.height * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VendorAppBar(title: "Manage Order"),
          Gap(height: 8),
          const AppText(
            text: "Keep track of your sales and logistics.",
            color: Colors.grey,
            fontSize: 16,
          ),
          Gap(height: 20),
          const VendorCustomSearchFilterRow(),
          Gap(height: 16),
        ],
      ),
    );
  }
}
