import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/my_order_list_model.dart';
import 'package:nexprime/services/repository/order_repository.dart';
import 'package:nexprime/services/storage/storage_services.dart';

final myOrderProvider =
    StateNotifierProvider<
      MyOrderListNotifier,
      AsyncValue<List<MyOrderListModel>>
    >((ref) {
      return MyOrderListNotifier()..fetchOrders();
    });

class MyOrderListNotifier
    extends StateNotifier<AsyncValue<List<MyOrderListModel>>> {
  MyOrderListNotifier() : super(const AsyncValue.loading());

  Future<void> fetchOrders() async {
    state = const AsyncValue.loading();
    try {
      var appRoll = await StorageServices.instance.getAppRoll();
      if (appRoll.toLowerCase() == "GUEST".toLowerCase()) {
        state = const AsyncValue.data([]);
        return;
      }

      final orders = await OrderRepository.instance.myAllOrder();
      state = AsyncValue.data(orders);
    } catch (e, stack) {
      state = AsyncValue.error(e.toString(), stack);
    }
  }
}
