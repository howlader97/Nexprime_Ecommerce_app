import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/static_page_model.dart';
import 'package:nexprime/services/repository/static_page_repository.dart';

final privacyPolicyProvider =
    StateNotifierProvider<PrivacyPolicyNotifier, AsyncValue<StaticPageModel?>>(
        (ref) {
  return PrivacyPolicyNotifier();
});

class PrivacyPolicyNotifier
    extends StateNotifier<AsyncValue<StaticPageModel?>> {
  PrivacyPolicyNotifier() : super(const AsyncValue.loading()) {
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      state = const AsyncValue.loading();
      final pages = await StaticPageRepository.instance.fetchStaticPages();
      final privacyPage = pages?.firstWhere((element) => element.key == "privacy");
      state = AsyncValue.data(privacyPage);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
