import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/models/marketing_product_model.dart';
import 'package:nexprime/services/repository/my_marketing_product_repository.dart';

final myMarketingProductProvider = FutureProvider<List<MarketingProductModel>>((ref) async {
  try {
    final response = await MyMarketingProductRepository.instance.fetchMyMarketingProducts();
    return response;
  } catch (e) {
    return [];
  }
});
