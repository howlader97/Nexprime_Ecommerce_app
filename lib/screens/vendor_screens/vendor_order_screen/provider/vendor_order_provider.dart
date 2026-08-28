import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:nexprime/utils/app_snack_bar.dart';
import '../../../../../models/vendor_order_model.dart';
import '../../../../../services/repository/vendor_order_repository.dart';

class VendorOrderNotifier extends AsyncNotifier<List<VendorOrderModel>> {
  @override
  FutureOr<List<VendorOrderModel>> build() async {
    final data = await VendorOrderRepository.instance.fetchVendorOrders();
    appLog("total orders: ${data.length}");
    return data;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => VendorOrderRepository.instance.fetchVendorOrders());
  }

  Future<void> archiveSubOrder(int id, bool status) async {
    final success = await VendorOrderRepository.instance.archiveSubOrder(id, status);
    if (success) {
      await refresh();
      AppSnackBar.instance.success("Order ${status ? 'Archived' : 'Unarchived'} Successfully");
    }
  }

  Future<void> completeSubOrder(int id, bool status) async {
    final success = await VendorOrderRepository.instance.completeSubOrder(id, status);
    if (success) {
      await refresh();
      AppSnackBar.instance.success("Order Mark Status Successfully");
    }
  }

  Future<void> fulfillSubOrder(int id, bool status, {String? trackingNumber, String? courierName}) async {
    final success = await VendorOrderRepository.instance.fulfillSubOrder(id, status, trackingNumber: trackingNumber, courierName: courierName);
    if (success) {
      await refresh();
      AppSnackBar.instance.success("Order Fulfilled Status Successfully");
    }
  }
}

final vendorOrderNotifierProvider = AsyncNotifierProvider<VendorOrderNotifier, List<VendorOrderModel>>(VendorOrderNotifier.new);

final orderSearchQueryProvider = StateProvider<String>((ref) => "");
final orderFilterStatusProvider = StateProvider<String>((ref) => "All");

final activeOrdersProvider = Provider<AsyncValue<List<VendorOrderModel>>>((ref) {
  final ordersAsync = ref.watch(vendorOrderNotifierProvider);
  final query = ref.watch(orderSearchQueryProvider).toLowerCase();
  final filter = ref.watch(orderFilterStatusProvider);

  return ordersAsync.when(
    data: (orders) {
      var filtered = orders.where((o) => o.isArchive == false).toList();

      // Apply Filter Status
      if (filter != "All") {
        filtered = filtered.where((o) {
          switch (filter) {
            case "Fulfilled":
              return o.isFulfield == true;
            case "Unfulfilled":
              return o.isFulfield == false;
            case "Paid":
              return o.isComplete == true;
            case "UnPaid":
              return o.isComplete == false;
            default:
              return true;
          }
        }).toList();
      }

      // Apply Search Query
      if (query.isNotEmpty) {
        filtered = filtered.where((o) {
          final matchesId = o.orderId.toString().contains(query);
          final matchesProduct = o.orderItems.any((item) => (item.productName ?? "").toLowerCase().contains(query));
          return matchesId || matchesProduct;
        }).toList();
      }

      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

final archivedOrdersProvider = Provider<AsyncValue<List<VendorOrderModel>>>((ref) {
  final ordersAsync = ref.watch(vendorOrderNotifierProvider);
  final query = ref.watch(orderSearchQueryProvider).toLowerCase();
  final filter = ref.watch(orderFilterStatusProvider);

  return ordersAsync.when(
    data: (orders) {
      var filtered = orders.where((o) => o.isArchive == true).toList();

      // Apply Filter Status
      if (filter != "All") {
        filtered = filtered.where((o) {
          switch (filter) {
            case "Fulfilled":
              return o.isFulfield == true;
            case "Unfulfilled":
              return o.isFulfield == false;
            case "Paid":
              return o.isComplete == true;
            case "UnPaid":
              return o.isComplete == false;
            default:
              return true;
          }
        }).toList();
      }

      // Apply Search Query
      if (query.isNotEmpty) {
        filtered = filtered.where((o) {
          final matchesId = o.orderId.toString().contains(query);
          final matchesProduct = o.orderItems.any((item) => (item.productName ?? "").toLowerCase().contains(query));
          return matchesId || matchesProduct;
        }).toList();
      }

      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});
