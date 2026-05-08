import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/marketing_product_model.dart';

class ReportArgs {
  final int userId;
  final String? name;
  final String? profileImageUrl;
  final MarketingProductModel? product;

  ReportArgs({
    required this.userId,
    this.name,
    this.profileImageUrl,
    this.product,
  });
}

final reportDataProvider = StateProvider<ReportArgs?>((ref) => null);