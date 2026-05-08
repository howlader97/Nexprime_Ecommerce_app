import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/models/marketing_product_model.dart';
import 'package:nexprime/services/repository/marketing_product_repository.dart';

final marketingProductProvider = FutureProvider<List<MarketingProductModel>>((ref) async {
  try {
    final response = await MarketingProductRepository.instance.fetchMarketingProducts();
    return response;
  } catch (e) {
    return [];
  }
});

final singleMarketingProductProvider = FutureProvider.family<MarketingProductModel?, int>((ref, id) async {
  try {
    return await MarketingProductRepository.instance.getMarketingProductById(id);
  } catch (e) {
    return null;
  }
});
