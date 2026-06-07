import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/screens/customer_screens/customer_order_screen/provider/customer_order_screen_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_order_screen/widgets/order_card.dart';
import 'package:nexprime/utils/app_size.dart';
import '../../../routes/app_routes.dart';

class CustomerOrderScreen extends ConsumerWidget {
  const CustomerOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(myOrderProvider);
    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                vertical: AppSize.size.height * 0.02,
              ),
              sliver: orderState.when(
                data: (orders) {
                  final allOrderItems = orders.expand((order) {
                    return order.subOrders.expand((subOrder) {
                      return subOrder.orderItems.map((orderItem) => (
                      order: order,
                      subOrder: subOrder,
                      orderItem: orderItem
                      ));
                    });
                  }).toList();

                  if (allOrderItems.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: AppSize.size.height * 0.3),
                          child: Text("No orders found", style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    );
                  }
                  return SliverList(
                      delegate: SliverChildBuilderDelegate(
                          childCount: allOrderItems.length,
                              (context, index) {
                            final item = allOrderItems[index];
                            final order = item.order;
                            final subOrder = item.subOrder;
                            final orderItem = item.orderItem;

                            String name = orderItem.product.name;
                            String image = "https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=150&q=80";
                            if (orderItem.product.images.isNotEmpty) {
                              image = orderItem.product.images[0]; // Image array index 0 is valid as it's the primary product image
                            }

                            String status = "Invalid";
                            bool isFulfilled = subOrder.isFulfield;
                            bool isCompleted = subOrder.isComplete;
                            bool isTrackOrderOpen = false;
                            bool isReviewSectionOpen = false;

                            if (isFulfilled == false && isCompleted == false) {
                              status = "Pending";
                              isTrackOrderOpen = false;
                              isReviewSectionOpen = false;
                            } else if (isFulfilled == true && isCompleted == false) {
                              status = "Shipped";
                              isTrackOrderOpen = true;
                              isReviewSectionOpen = false;
                            } else if (isFulfilled == true && isCompleted == true) {
                              status = "Delivered";
                              isTrackOrderOpen = true;
                              isReviewSectionOpen = true;
                            }

                            return OrderCard(
                              onPressed: () {
                                AppRoutes.instance.pushNamed(
                                    AppRoutesKey.instance.customerReviewScreen,extra: order.id
                                );
                              },
                              isReviewSectionOpen: isReviewSectionOpen,
                              isTrackOrderOpen: isTrackOrderOpen,
                              trackingUrl: subOrder.trackingUrl,
                              date: "${order.createdAt.day.toString().padLeft(2, '0')}/${order.createdAt.month.toString().padLeft(2, '0')}/${order.createdAt.year}",
                              orderId: "#ORD-${order.id}",
                              status: status,
                              productName: name,
                              productImageUrl: image,
                            );
                          }
                      )
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
    );
  }
}
