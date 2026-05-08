import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/faq_model.dart';
import 'package:nexprime/services/repository/faq_repository.dart';

final faqProvider = StateNotifierProvider<FaqNotifier, AsyncValue<List<FaqModel>>>((ref) {
  return FaqNotifier();
});

class FaqNotifier extends StateNotifier<AsyncValue<List<FaqModel>>> {
  FaqNotifier() : super(const AsyncValue.loading()) {
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    try {
      state = const AsyncValue.loading();
      final response = await FaqRepository.instance.fetchFaqs();
      state = AsyncValue.data(response ?? []);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
