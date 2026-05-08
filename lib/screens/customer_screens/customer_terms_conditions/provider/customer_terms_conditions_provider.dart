import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/static_page_model.dart';
import 'package:nexprime/services/repository/static_page_repository.dart';

final termsAndConditionsProvider =
    StateNotifierProvider<TermsAndConditionsNotifier, AsyncValue<StaticPageModel?>>(
        (ref) {
  return TermsAndConditionsNotifier();
});

class TermsAndConditionsNotifier
    extends StateNotifier<AsyncValue<StaticPageModel?>> {
  TermsAndConditionsNotifier() : super(const AsyncValue.loading()) {
    fetchTermsAndConditions();
  }

  Future<void> fetchTermsAndConditions() async {
    try {
      state = const AsyncValue.loading();
      final pages = await StaticPageRepository.instance.fetchStaticPages();
      final termsPage = pages?.firstWhere((element) => element.key == "Terms");
      state = AsyncValue.data(termsPage);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
