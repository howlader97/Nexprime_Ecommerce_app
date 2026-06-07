import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/utils/app_snack_bar.dart';

import '../../../../services/repository/order_repository.dart';

final customerReviewProvider =
ChangeNotifierProvider((ref) => CustomerReviewProvider());

class CustomerReviewProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> submitReview({
    required int score,
    required String reviewText,
    required int orderId,
  }) async {
    if (score == 0) {
      AppSnackBar.instance.error("Please select a rating");
      return;
    }
    if (reviewText.isEmpty) {
      AppSnackBar.instance.error("Please write a review");
      return;
    }

    _isLoading = true;
    notifyListeners();

    bool success = await OrderRepository.instance.review(
      score: score,
      reviewText: reviewText,
      id: orderId,
    );

    _isLoading = false;
    notifyListeners();

    if (success) {
      AppSnackBar.instance.success("Review submitted successfully");
      AppRoutes.instance.pop();
    }
  }
}