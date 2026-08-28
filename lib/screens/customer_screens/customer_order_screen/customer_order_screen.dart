import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/screens/customer_screens/customer_order_screen/provider/customer_order_screen_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_order_screen/widgets/customer_order_card.dart';
import 'package:nexprime/utils/app_size.dart';

class CustomerOrderScreen extends ConsumerWidget {
  const CustomerOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(myOrderProvider);
    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.instance.primary,
          onRefresh: () async {
            ref.invalidate(myOrderProvider);
          },
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.04,
                  vertical: AppSize.size.height * 0.015,
                ),
                sliver: orderState.when(
                  data: (orders) {
                    if (orders.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: AppSize.size.height * 0.3),
                            child: const Text("No orders found", style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: orders.length,
                        (context, index) {
                          final order = orders[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: CustomerOrderCard(
                              order: order,
                              onRefresh: () {
                                ref.invalidate(myOrderProvider);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(
                    child: Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
                  ),
                  error: (err, stack) => SliverToBoxAdapter(
                    child: Center(child: Padding(padding: EdgeInsets.all(20), child: Text("Error: $err"))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
