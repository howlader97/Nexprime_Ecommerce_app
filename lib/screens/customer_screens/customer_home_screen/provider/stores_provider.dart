import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/store_model.dart';
import 'package:nexprime/services/repository/home_repository.dart';
import 'package:nexprime/utils/app_log.dart';

final storesProvider =
    StateNotifierProvider<StoresNotifier, List<StoreModel>?>((ref) {
  return StoresNotifier();
});

class StoresNotifier extends StateNotifier<List<StoreModel>?> {
  StoresNotifier() : super(null) {
    getStores();
  }

  Future<void> getStores() async {
    try {
      final response = await HomeRepository.instance.fetchStores();
      state = response;
    } catch (e) {
      errorLog("stores error", e);
      state = [];
    }
  }
}
