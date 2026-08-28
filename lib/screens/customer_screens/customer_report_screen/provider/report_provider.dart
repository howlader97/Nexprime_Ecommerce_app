import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/screens/customer_screens/customer_report_screen/provider/report_data_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_profile_screen/provider/customer_profile_provider.dart';
import 'package:nexprime/utils/app_snack_bar.dart';
import '../../../../services/repository/report_repository.dart';

final reportProvider = StateNotifierProvider<ReportNotifier, AsyncValue<String?>>((ref) => ReportNotifier(ref));

class ReportNotifier extends StateNotifier<AsyncValue<String?>> {
  final Ref ref;

  ReportNotifier(this.ref) : super(const AsyncData(null));

  Future<void> submitReport({required BuildContext context, required List<String> selectedReasons, required String othersText}) async {
    state = const AsyncLoading();

    try {
      final reportData = ref.read(reportDataProvider);
      final user = ref.read(customerProfileProvider);

      // ✅ Combine all reasons properly
      final List<String> allReasons = [];

      if (selectedReasons.isNotEmpty) {
        allReasons.addAll(selectedReasons);
      }

      if (othersText.trim().isNotEmpty) {
        allReasons.add(othersText.trim());
      }

      final String content = allReasons.join(", ");

      // ✅ Validation
      if (content.trim().isEmpty) {
        state = AsyncError("Please select or write a reason", StackTrace.current);
        return;
      }

      // ✅ API CALL
      final response = await ReportRepository.instance.reportData(
        reporterUserId: user.value?.id ?? 0,
        targetUserId: reportData?.userId ?? 0,
        productId: reportData?.product?.id ?? 0,
        content: content,
      );

      if (response != null) {
        state = const AsyncData("success");

        AppSnackBar.instance.success("Report submitted successfully");

        AppRoutes.instance.pop();
      } else {
        state = AsyncError("Failed to submit report", StackTrace.current);
      }
    } catch (e, stack) {
      state = AsyncError(e.toString(), stack);
    }
  }
}
