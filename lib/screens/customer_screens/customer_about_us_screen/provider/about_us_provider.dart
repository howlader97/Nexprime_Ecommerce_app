

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../models/static_page_model.dart';
import '../../../../services/repository/static_page_repository.dart';

final aboutUsProvider =
StateNotifierProvider<AboutUsNotifier, AsyncValue<StaticPageModel?>>(
        (ref) {
      return AboutUsNotifier();
    });

class AboutUsNotifier
    extends StateNotifier<AsyncValue<StaticPageModel?>> {
  AboutUsNotifier() : super(const AsyncValue.loading()) {
    fetchAboutUs();
  }

  Future<void> fetchAboutUs() async {
    try {
      state = const AsyncValue.loading();
      final pages = await StaticPageRepository.instance.fetchStaticPages();
      final termsPage = pages?.firstWhere((element) => element.key == "About");
      state = AsyncValue.data(termsPage);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
