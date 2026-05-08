import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/review_model.dart';
import 'package:nexprime/services/repository/product_repository.dart';
import 'package:nexprime/utils/app_log.dart';
final reviewProvider =
StateNotifierProvider.family<ProductReview, AsyncValue<List<ReviewModel>>,
    int
>((ref, id) {
  return ProductReview(id);
});

class ProductReview extends StateNotifier<AsyncValue<List<ReviewModel>>> {
  final int id;

  ProductReview(this.id) : super(AsyncLoading()) {
    getReview();
  }

  Future<void> getReview() async {

    state = AsyncValue.loading();
    try {
      final reviewData = await ProductRepository.instance.fetchReview(id);
      state = AsyncData(reviewData);
    } catch (e) {
      errorLog("product is", e);
    }
  }
}
