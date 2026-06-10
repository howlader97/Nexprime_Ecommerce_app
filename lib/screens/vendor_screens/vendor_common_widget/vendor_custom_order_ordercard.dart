import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nexprime/screens/vendor_screens/vendor_common_widget/vendor_custom_text_title16.dart';
import 'package:nexprime/models/vendor_order_model.dart';
import 'package:nexprime/screens/vendor_screens/vendor_order_screen/provider/vendor_order_provider.dart';
import '../../../constant/app_colors.dart';
import '../../../utils/gap.dart';
import '../../../widgets/texts/app_text.dart';

class VendorCustomOrderOrdercard extends ConsumerWidget {
  final VendorOrderModel order;
  const VendorCustomOrderOrdercard({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Calculate total quantity
    int totalQuantity = order.orderItems.fold(0, (sum, item) => sum + (item.quantity ?? 0));
    String time = DateFormat('hh:mm a').format(order.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.instance.dark50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VendorCustomTextTitle16(title: "Order NO. #${order.orderId}"),
                      const Gap(height: 8),
                      AppText(
                        text: "$totalQuantity item${totalQuantity > 1 ? 's' : ''} • $time",
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                _OrderPopupMenu(order: order),
              ],
            ),
            const Gap(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    StatusChip(
                      order.isFulfield ? "Fulfilled" : "Unfulfilled",
                      color: order.isFulfield ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    StatusChip(
                      order.order?.isPaid == true ? "Paid" : "Unpaid",
                      color:order.order?.isPaid == true ? Colors.green : Colors.red,
                    ),
                  ],
                ),
                AppText(
                  text: "\$${order.subTotal}",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderPopupMenu extends ConsumerWidget {
  final VendorOrderModel order;
  const _OrderPopupMenu({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(vendorOrderNotifierProvider.notifier);

    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
      onSelected: (value) {
        switch (value) {
          case "Archive":
            notifier.archiveSubOrder(order.id, true);
            break;
          case "Unarchive":
            notifier.archiveSubOrder(order.id, false);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: order.isArchive ? "Unarchive" : "Archive",
          child: AppText(text: order.isArchive ? "Unarchive" : "Archive"),
        ),
      ],
    );
  }
}

class StatusChip extends StatelessWidget {
  final String text;
  final Color color;
  const StatusChip(this.text, {super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AppText( text:
      text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}
