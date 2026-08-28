import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/marketing_product_model.dart';
import 'package:nexprime/services/repository/marketing_product_repository.dart';
import 'package:nexprime/utils/app_log.dart';

// ---------------------------------------------------------------------------
// Filter state
// ---------------------------------------------------------------------------
class MarketingFilter {
  final String? goodsType;
  final String? location;

  const MarketingFilter({this.goodsType, this.location});

  MarketingFilter copyWith({
    Object? goodsType = _sentinel,
    Object? location = _sentinel,
  }) {
    return MarketingFilter(
      goodsType: goodsType == _sentinel ? this.goodsType : goodsType as String?,
      location: location == _sentinel ? this.location : location as String?,
    );
  }
}

const _sentinel = Object();

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------
final marketingProductProvider =
    StateNotifierProvider<
      MarketingProductNotifier,
      AsyncValue<List<MarketingProductModel>>
    >((ref) {
      return MarketingProductNotifier();
    });

class MarketingProductNotifier
    extends StateNotifier<AsyncValue<List<MarketingProductModel>>> {
  MarketingFilter _filter = const MarketingFilter();

  MarketingProductNotifier() : super(const AsyncValue.loading()) {
    _fetchProducts();
  }

  // Apply filter — pass null to clear a specific filter
  Future<void> filter({
    Object? goodsType = _sentinel,
    Object? location = _sentinel,
  }) async {
    _filter = _filter.copyWith(goodsType: goodsType, location: location);
    await _fetchProducts();
  }

  Future<void> refresh() async {
    await _fetchProducts();
  }

  /// Clears all active filters then re-fetches from the server.
  Future<void> resetAndRefresh() async {
    _filter = const MarketingFilter();
    await _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    state = const AsyncValue.loading();
    try {
      final products = await MarketingProductRepository.instance
          .fetchMarketingProducts(
            goodsType: _filter.goodsType,
            location: _filter.location,
          );
      state = AsyncValue.data(products);
    } catch (e, st) {
      errorLog("marketingProductProvider error", e);
      state = AsyncValue.error(e, st);
    }
  }
}

final singleMarketingProductProvider =
    FutureProvider.family<MarketingProductModel?, int>((ref, id) async {
      try {
        return await MarketingProductRepository.instance
            .getMarketingProductById(id);
      } catch (e) {
        return null;
      }
    });
