import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/models/my_order_list_model.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/services/repository/order_repository.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/app_snack_bar.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/buttons/custom_decorated_box.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

class CustomerOrderCard extends StatefulWidget {
  final MyOrderListModel order;
  final VoidCallback onRefresh;

  const CustomerOrderCard({
    super.key,
    required this.order,
    required this.onRefresh,
  });

  @override
  State<CustomerOrderCard> createState() => _CustomerOrderCardState();
}

class _CustomerOrderCardState extends State<CustomerOrderCard> {
  final Map<int, bool> _submittingSubOrders = {};

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final formattedDate =
        "${order.createdAt.day.toString().padLeft(2, '0')}/${order.createdAt.month.toString().padLeft(2, '0')}/${order.createdAt.year}";

    return CustomDecoratedBox(
      child: Padding(
        padding: EdgeInsets.all(AppSize.size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Order ID, Date & Total Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: formattedDate,
                      fontSize: AppSize.size.width * 0.035,
                      color: AppColors.instance.gray400,
                    ),
                    Gap(height: AppSize.size.width * 0.011),
                    AppText(
                      text: "#ORD-${order.id}",
                      fontSize: AppSize.size.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(
                      text: "¥${order.totalAmount.toStringAsFixed(2)}",
                      fontSize: AppSize.size.width * 0.045,
                      fontWeight: FontWeight.bold,
                      color: AppColors.instance.green,
                    ),
                    Gap(height: AppSize.size.width * 0.011),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: order.isPaid
                            ? AppColors.instance.green.withValues(alpha: 0.15)
                            : Colors.orange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: AppText(
                        text: order.isPaid ? "Paid" : "Unpaid",
                        color: order.isPaid ? AppColors.instance.green : Colors.orange.shade800,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),

            // Packages (SubOrders) List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.subOrders.length,
              separatorBuilder: (context, index) => const Divider(height: 24, thickness: 0.5),
              itemBuilder: (context, index) {
                final subOrder = order.subOrders[index];
                return _buildSubOrderPackage(context, subOrder);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubOrderPackage(BuildContext context, SubOrder subOrder) {
    final storeName = subOrder.store?.name ?? "Vendor Store";
    final isFulfilled = subOrder.isFulfield;
    final isCompleted = subOrder.isComplete;
    final isSubmitting = _submittingSubOrders[subOrder.id] ?? false;

    String packageStatus = "Pending";
    Color statusColor = Colors.grey.shade700;
    Color statusBg = Colors.grey.shade200;

    if (!isFulfilled && !isCompleted) {
      packageStatus = "Processing / Pending";
      statusColor = Colors.orange.shade800;
      statusBg = Colors.orange.shade50;
    } else if (isFulfilled && !isCompleted) {
      packageStatus = "Shipped 🚚";
      statusColor = Colors.blue.shade800;
      statusBg = Colors.blue.shade50;
    } else if (isFulfilled && isCompleted) {
      packageStatus = "Delivered ✅";
      statusColor = AppColors.instance.green;
      statusBg = AppColors.instance.green.withValues(alpha: 0.15);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Store Package Header & Status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.storefront, size: 18, color: AppColors.instance.green),
                const Gap(width: 6),
                AppText(
                  text: storeName,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.instance.black06,
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: AppText(
                text: packageStatus,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ],
        ),
        const Gap(height: 10),

        // Items in this package
        Column(
          children: subOrder.orderItems.map((item) {
            String imageUrl =
                "https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=150&q=80";
            if (item.product.images.isNotEmpty) {
              imageUrl = item.product.images[0];
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: AppImage(url: imageUrl, fit: BoxFit.cover),
                  ),
                  const Gap(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: item.product.name,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                        ),
                        const Gap(height: 4),
                        Row(
                          children: [
                            if (item.size != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "Size: ${item.size}",
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                                ),
                              ),
                              const Gap(width: 6),
                            ],
                            if (item.color != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "Color: ${item.color}",
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                                ),
                              ),
                              const Gap(width: 6),
                            ],
                            Text(
                              "Qty: ${item.quantity}",
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppText(
                    text: "¥${(item.price * item.quantity).toStringAsFixed(2)}",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            );
          }).toList(),
        ),

        // Action Buttons for this package
        if (isFulfilled) ...[
          const Gap(height: 6),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    AppRoutes.instance.pushNamed(
                      AppRoutesKey.instance.customerOrderTrackList,
                      extra: {
                        'trackingUrl': subOrder.trackingUrl ?? '',
                        'subOrderId': subOrder.id,
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.local_shipping_outlined, size: 16, color: AppColors.instance.green),
                      const Gap(width: 4),
                      AppText(
                        text: "Track Package",
                        fontSize: 13,
                        color: AppColors.instance.green,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.instance.green,
                      ),
                    ],
                  ),
                ),
              ),
              if (isCompleted)
                Expanded(
                  child: AppButton(
                    title: "Give Feedback",
                    backgroundColor: Colors.transparent,
                    borderColor: Colors.grey.shade400,
                    titleColor: AppColors.instance.black500,
                    height: 38,
                    onTap: () {
                      AppRoutes.instance.pushNamed(
                        AppRoutesKey.instance.customerReviewScreen,
                        extra: widget.order.id,
                      );
                    },
                  ),
                ),
            ],
          ),
        ],

        if (isFulfilled && !isCompleted) ...[
          const Gap(height: 10),
          isSubmitting
              ? const Center(child: CircularProgressIndicator())
              : AppButton(
                  title: "Confirm Delivery Received (ডেলিভারি গ্রহণ নিশ্চিত করুন)",
                  backgroundColor: AppColors.instance.green,
                  borderColor: AppColors.instance.green,
                  titleColor: Colors.white,
                  height: 42,
                  onTap: () async {
                    setState(() => _submittingSubOrders[subOrder.id] = true);
                    final success = await OrderRepository.instance.confirmOrderReceipt(subOrder.id);
                    if (mounted) setState(() => _submittingSubOrders[subOrder.id] = false);
                    if (success) {
                      AppSnackBar.instance.success("Delivery confirmed! Vendor payment released.");
                      widget.onRefresh();
                    }
                  },
                ),
        ],
      ],
    );
  }
}
