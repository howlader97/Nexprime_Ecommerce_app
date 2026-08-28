import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/constant/app_locations.dart';

import '../../customer_profile_screen/provider/customer_profile_provider.dart';

final marketPlaceLocationProvider = StateNotifierProvider(
  (ref) => _MarketplaceLocationProvider(ref),
);

class _MarketplaceLocationProvider extends StateNotifier<String> {
  final Ref _ref;

  _MarketplaceLocationProvider(this._ref) : super("") {
    loadLocation();
  }

  void update(String? value) {
    if (value != null) {
      state = value;
    }
  }

  void clear() {
    state = "";
  }

  Future<void> loadLocation() async {
    try {
      var location = _ref.read(customerProfileProvider).asData?.value?.location;
      if (appLocations.contains(location)) {
        state = location ?? "";
      }
    } catch (e) {
      state = "";
    }
  }
}
