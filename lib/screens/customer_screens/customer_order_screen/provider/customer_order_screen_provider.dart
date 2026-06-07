
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/services/repository/order_repository.dart';

import '../../../../models/my_order_list_model.dart';

final myOrderProvider = StateNotifierProvider<MyOrderListNotifier, AsyncValue<List<MyOrderListModel>>>((ref) {
  return MyOrderListNotifier()..fetchOrders();
});

class MyOrderListNotifier extends StateNotifier<AsyncValue<List<MyOrderListModel>>> {
  MyOrderListNotifier() : super(const AsyncValue.loading());

  Future<void> fetchOrders() async {
    state = const AsyncValue.loading();
    try {
      final orders = await OrderRepository.instance.myAllOrder();
      if (orders != null) {
        state = AsyncValue.data(orders);
      } else {
        state = AsyncValue.error("Failed to fetch orders", StackTrace.current);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e.toString(), stack);
    }
  }
}