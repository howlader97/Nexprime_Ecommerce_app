import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/screens/vendor_screens/vendor_order_success/vendor_order_success.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../../../models/vendor_order_model.dart';
import '../../../../utils/gap.dart';
import '../../../customer_screens/customer_order_track_list/customer_order_track_list.dart';
import '../../vendor_order_screen/provider/vendor_order_provider.dart';

class VendorCustomerOrderActionButton extends ConsumerWidget {
  final VendorOrderModel orderModel;
  const VendorCustomerOrderActionButton({super.key, required this.orderModel});

  void _showTrackingDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Center(
            child: AppText(
              text: "Order Fulfillment",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.instance.black500,
                fontSize: 18,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: "Courier Name",
                style: TextStyle(
                  color: AppColors.instance.gray300,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.instance.white200,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.instance.white400),
                ),
                child: AppText(
                  text: "Japan Post",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.instance.black500,
                  ),
                ),
              ),
              const Gap(height: 16),
              AppText(
                text: "Japan Post Order Tracking ID",
                style: TextStyle(
                  color: AppColors.instance.gray300,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(height: 6),
              TextField(
                controller: controller,
                style: TextStyle(color: AppColors.instance.black500),
                decoration: InputDecoration(
                  hintText: "Enter tracking number (e.g. HPRUID869)",
                  hintStyle: TextStyle(color: AppColors.instance.gray100, fontSize: 13),
                  filled: true,
                  fillColor: AppColors.instance.white200,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.instance.white400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.instance.green, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: AppText(
                text: "Cancel",
                style: TextStyle(color: AppColors.instance.gray200, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.instance.green,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                final trackingNumber = controller.text.trim();
                if (trackingNumber.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a valid tracking ID"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                Navigator.pop(context);
                ref.read(vendorOrderNotifierProvider.notifier).fulfillSubOrder(
                  orderModel.id,
                  true,
                  trackingNumber: trackingNumber,
                  courierName: "Japan Post",
                );
              },
              child: const AppText(
                text: "Confirm",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isFulfilled = orderModel.isFulfield;
    final bool isComplete = orderModel.isComplete;

    String buttonText = "Mark as full filled";
    VoidCallback? onPressed;

    if (!isFulfilled && !isComplete) {
      buttonText = "Mark as full filled";
      onPressed = () {
        _showTrackingDialog(context, ref);
      };
    } else if (isFulfilled && !isComplete) {
      buttonText = "Delivered";
      onPressed = () {
        ref.read(vendorOrderNotifierProvider.notifier).completeSubOrder(orderModel.id, true);
      };
    } else {
      // Both are true
      buttonText = "Delivered";
      onPressed = null; // This disables the button
    }

    final String trackButtonText = (orderModel.trackingUrl != null && orderModel.trackingUrl!.isNotEmpty)
        ? "Track Order"
        : "Add Track";

    final VoidCallback onTrackPressed = (orderModel.trackingUrl != null && orderModel.trackingUrl!.isNotEmpty)
        ? () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomerOrderTrackList(trackingUrl: orderModel.trackingUrl!),
        ),
      );
    }
        : () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VendorOrderSuccess()),
      );
    };

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            child: AppText(text: buttonText),
          ),
        ),
        if (isFulfilled) ...[
          const Gap(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onTrackPressed,
              child: AppText(text: trackButtonText),
            ),
          ),
        ],
      ],
    );
  }
}
