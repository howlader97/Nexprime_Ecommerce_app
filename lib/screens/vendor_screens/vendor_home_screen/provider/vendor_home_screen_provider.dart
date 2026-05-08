import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/vendor_dashboard_model.dart';
import 'package:nexprime/services/repository/vendor_dashboard_repository.dart';

final vendorDashboard =
    StateNotifierProvider<DashboardScreen, AsyncValue<VendorDashboardModel>>((
      ref,
    ) {
      return DashboardScreen();
    });

class DashboardScreen extends StateNotifier<AsyncValue<VendorDashboardModel>> {
  DashboardScreen() : super(AsyncLoading()){getDashboardData();}

  Future<void> getDashboardData() async {
    try {
      state = const AsyncLoading();
      final response = await VendorDashboardRepository.instance.dashboardData();
      state = AsyncData(response!);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
