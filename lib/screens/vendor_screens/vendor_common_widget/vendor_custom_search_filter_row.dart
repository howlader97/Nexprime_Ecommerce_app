import 'package:flutter/material.dart';
import '../../../utils/app_size.dart';
import '../../../utils/gap.dart';
import '../../../widgets/texts/app_text.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/screens/vendor_screens/vendor_order_screen/provider/vendor_order_provider.dart';

class VendorCustomSearchFilterRow extends ConsumerWidget {
  const VendorCustomSearchFilterRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(orderFilterStatusProvider);

    return Row(
      children: [
        /// SEARCH BOX
        Expanded(
          flex: 5,
          child: TextField(
            onChanged: (val) => ref.read(orderSearchQueryProvider.notifier).state = val,style: TextStyle(color: Colors.black),
            decoration:  InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 11, horizontal: 0),
              hintText: "Search by name or ID",
              hintStyle: TextStyle(color: Colors.black, fontSize: 13),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.black,
                  )
              ),
              isDense: true,


            ),
          ),
        ),

        Gap(width: 8),

        /// FILTER BUTTON
        Expanded(
          flex: 5,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.size.width * 0.05,
              vertical: AppSize.size.height * 0.0095,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: PopupMenuButton<String>(
              position: PopupMenuPosition.under,
              onSelected: (value) => ref.read(orderFilterStatusProvider.notifier).state = value,
              itemBuilder: (context) => const [
                PopupMenuItem(value: "Fulfilled", child: AppText( text: "Fulfilled")),
                PopupMenuItem(value: "Unfulfilled", child: AppText( text: "Unfulfilled")),
                PopupMenuItem(value: "Paid", child: AppText( text: "Paid")),
                PopupMenuItem(value: "UnPaid", child: AppText( text: "UnPaid")),
                PopupMenuItem(value: "All", child: AppText( text: "All")),
              ],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(child: AppText(text: currentFilter == "All" ? "Order Filters" : currentFilter, maxLines: 1)),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
