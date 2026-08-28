import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/services/repository/vendor_dashboard_repository.dart';

final vendorHomeDropdownProvider = StateProvider<String?>((ref) => null);
final vendorHomeStartDateProvider = StateProvider<String?>((ref) => null);
final vendorHomeEndDateProvider = StateProvider<String?>((ref) => null);

final vendorDashboard = StateNotifierProvider<DashboardScreen, AsyncValue<dynamic>>((ref) {
  final selectedFilter = ref.watch(vendorHomeDropdownProvider);
  final startDate = ref.watch(vendorHomeStartDateProvider);
  final endDate = ref.watch(vendorHomeEndDateProvider);
  return DashboardScreen(filterType: selectedFilter, startDate: startDate, endDate: endDate);
});

class DashboardScreen extends StateNotifier<AsyncValue<dynamic>> {
  final String? filterType;
  final String? startDate;
  final String? endDate;

  DashboardScreen({this.filterType, this.startDate, this.endDate}) : super(const AsyncLoading()) {
    getDashboardData();
  }

  Future<void> getDashboardData() async {
    try {
      if (filterType == 'custom' && (startDate == null || endDate == null)) {
        state = const AsyncLoading();
        return;
      }
      state = const AsyncLoading();
      final response = await VendorDashboardRepository.instance.dashboardData(filterType: filterType, startDate: startDate, endDate: endDate);
      state = AsyncData(response!);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
