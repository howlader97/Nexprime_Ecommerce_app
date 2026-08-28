// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:nexprime/screens/customer_screens/customer_profile_screen/provider/customer_my_balance_provider.dart';
// import 'package:nexprime/screens/customer_screens/customer_profile_screen/widgets/customer_add_balance_widget.dart';
// import 'package:nexprime/widgets/texts/app_text.dart';
// import 'package:skeletonizer/skeletonizer.dart';

// class CustomerBalanceCard extends ConsumerWidget {
//   const CustomerBalanceCard({super.key});
//
//   @override
//   Widget build(BuildContext context, ref) {
//     final provider = ref.watch(customerMyBalanceProvider);
//     return provider.when(
//       loading: () => const _Loader(),
//       error: (error, stackTrace) => _BalanceWidget(
//         balance: 0.0,
//         onAddBalance: () {
//           showAddBalanceDialog(
//             context: context,
//             isError: true,
//             currentBalance: 0.0,
//             onAddBalance: (value) {
//               ref.read(customerMyBalanceProvider.notifier).addCustomerBalance(value);
//             },
//           );
//         },
//         isError: true,
//       ),
//       data: (balance) => _BalanceWidget(
//         balance: balance,
//         onAddBalance: () {
//           showAddBalanceDialog(
//             context: context,
//             isError: false,
//             currentBalance: balance,
//             onAddBalance: (value) {
//               ref.read(customerMyBalanceProvider.notifier).addCustomerBalance(value);
//             },
//           );
//         },
//         isError: false,
//       ),
//     );
//   }
// }
//
// class _BalanceWidget extends StatelessWidget {
//   const _BalanceWidget({this.isError = false, required this.balance, required this.onAddBalance});
//   final double balance;
//   final VoidCallback onAddBalance;
//   final bool isError;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Gap(height: 8),
//        // AppText(text: "Marketplace publishing balance", color: Colors.green, fontWeight: FontWeight.w500, fontSize: 14),
//         // Gap(height: 5),
//         // Container(
//         //   width: double.infinity,
//         //   padding: const EdgeInsets.all(16),
//         //   decoration: BoxDecoration(
//         //     color: const Color(0xFFF5F6F4),
//         //     borderRadius: BorderRadius.circular(12),
//         //     border: Border.all(color: Colors.grey.shade300),
//         //   ),
//         //   child: Column(
//         //     crossAxisAlignment: CrossAxisAlignment.start,
//         //     children: [
//         //       /// Balance Row
//         //       Row(
//         //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //         children: [
//         //           AppText(
//         //             text: "My Balance",
//         //             style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
//         //           ),
//         //           AppText(
//         //             text: isError ? "..." : "¥${balance.toStringAsFixed(0)}",
//         //             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
//         //           ),
//         //         ],
//         //       ),
//         //
//         //       const SizedBox(height: 20),
//         //
//         //      // Add Balance Button
//         //       SizedBox(
//         //         width: double.infinity,
//         //         height: 48,
//         //         child: ElevatedButton(
//         //           onPressed: onAddBalance,
//         //           style: ElevatedButton.styleFrom(
//         //             backgroundColor: const Color(0xFF4B9B4F),
//         //             foregroundColor: Colors.white,
//         //             elevation: 0,
//         //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//         //           ),
//         //           child: const Text("Add Balance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//         //         ),
//         //       ),
//         //     ],
//         //   ),
//         // ),
//       ],
//     );
//   }
// }
//
// class _Loader extends StatelessWidget {
//   const _Loader();
//
//   @override
//   Widget build(BuildContext context) {
//     return Skeletonizer(
//       enabled: true,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF5F6F4),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Balance Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("My Balance", style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
//                 Text(
//                   "¥10",
//                   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 20),
//
//             /// Add Balance Button
//             SizedBox(
//               width: double.infinity,
//               height: 48,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF4B9B4F),
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                 ),
//                 child: const Text("Add Balance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
