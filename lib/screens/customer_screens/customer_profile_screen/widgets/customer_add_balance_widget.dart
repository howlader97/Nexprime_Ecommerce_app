import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexprime/constant/app_constant.dart';
import 'package:nexprime/utils/app_snack_bar.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

void showAddBalanceDialog({
  required BuildContext context,
  required double currentBalance,
  bool isError = false,
  required void Function(String value) onAddBalance,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomerAddBalanceWidget(currentBalance: currentBalance, isError: isError, onAddBalance: onAddBalance);
    },
  );
}

class CustomerAddBalanceWidget extends StatefulWidget {
  final double currentBalance;
  final bool isError;
  final void Function(String value) onAddBalance;

  const CustomerAddBalanceWidget({super.key, required this.currentBalance, required this.isError, required this.onAddBalance});

  @override
  State<CustomerAddBalanceWidget> createState() => _CustomerAddBalanceWidgetState();
}

class _CustomerAddBalanceWidgetState extends State<CustomerAddBalanceWidget> {
  late TextEditingController amountController;

  final List<int> quickAmounts = [10, 20, 50, 100];

  @override
  void initState() {
    amountController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // color: const Color(0xFFF5F6F4),
    //   borderRadius: BorderRadius.circular(12),
    //   border: Border.all(color: Colors.grey.shade300),
    return Dialog(
      backgroundColor: const Color(0xFFF5F6F4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Title
            AppText(text: "Add Balance", color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),

            const SizedBox(height: 20),

            /// Current Balance
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(text: "Current Balance", color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w600),
                  const SizedBox(height: 6),
                  AppText(
                    text: widget.isError ? "..." : "¥${widget.currentBalance.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Amount
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
              decoration: InputDecoration(
                labelText: "Enter Amount",
                labelStyle: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w600, fontFamily: AppConstant.instance.openSans),
                helperStyle: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w400, fontFamily: AppConstant.instance.openSans),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: AppText(text: "¥",color:Colors.black54,fontSize: 26,),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 50),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: TextStyle(fontSize: 18, color: Colors.black, fontFamily: AppConstant.instance.openSans, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 18),

            /// Quick Amount
            Align(
              alignment: Alignment.centerLeft,
              child: AppText(text: "Quick Amount", fontWeight: FontWeight.w600, color: Colors.grey.shade700),
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 10,
                children: quickAmounts.map((amount) {
                  return ActionChip(
                    backgroundColor: amount == double.tryParse(amountController.text) ? Colors.green : Colors.grey.shade300,
                    label: AppText(text: "¥$amount", fontWeight: FontWeight.w500),
                    onPressed: () {
                      amountController.text = amount.toString();
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            /// Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const AppText(text: "Cancel", color: Colors.red, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      final amount = double.tryParse(amountController.text);

                      if (amount == null || amount <= 0) {
                        AppSnackBar.instance.error("Please enter a valid amount.");
                        return;
                      }

                      Navigator.pop(context, amount);
                      widget.onAddBalance(amountController.text);
                    },
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.green), foregroundColor: WidgetStatePropertyAll(Colors.white)),
                    child: const AppText(text: "Add Balance", color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
