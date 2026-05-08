import 'package:flutter/material.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/widgets/buttons/custom_app_bar.dart';
import '../../../utils/app_size.dart';
import '../../../utils/gap.dart';
import '../../../widgets/texts/app_text.dart';
import '../vendor_common_widget/vendor_custom_order_ordercard.dart';
import '../vendor_common_widget/vendor_custom_search_filter_row.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/screens/vendor_screens/vendor_order_screen/provider/vendor_order_provider.dart';

class VendorViewArchive extends ConsumerWidget {
  const VendorViewArchive({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archivedAsync = ref.watch(archivedOrdersProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(vendorOrderNotifierProvider.notifier).refresh(),
          child: archivedAsync.when(
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
                              text: "No archived orders found",
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final order = orders[index];
                              return VendorCustomOrderOrdercard(order: order);
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
       //   VendorAppBar(title: "Order Archive"),
          CustomAppBar(backButton:(){
            AppRoutes.instance.pop();
          },title: "Order Archive",),
          Gap(height: 8),
          const AppText(
            text: "Review your archived orders.",
            color: Colors.grey,
            fontSize: 16,
          ),
          Gap(height: 20),
          const VendorCustomSearchFilterRow(),
        ],
      ),
    );
  }
}
