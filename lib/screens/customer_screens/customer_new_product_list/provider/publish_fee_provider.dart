import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/repository/marketing_product_repository.dart';

final publishingFeeProvider = FutureProvider<double>((ref) async {
  return await MarketingProductRepository.instance.getPublishFee();
});

