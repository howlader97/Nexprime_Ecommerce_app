import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageProvider =
NotifierProvider<PageControllerNotifier, int>(PageControllerNotifier.new);

class PageControllerNotifier extends Notifier<int> {

  @override
  int build() {
    return 0;
  }

  void changePage(int index) {
    state = index;
  }

  void nextPage(int length) {
    if (state < length - 1) {
      state++;
    }
  }

  void previousPage() {
    if (state > 0) {
      state--;
    }
  }
}