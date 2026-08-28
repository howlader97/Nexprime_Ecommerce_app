import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/groceries_country_model.dart';
import 'package:nexprime/services/repository/home_repository.dart';
import 'package:nexprime/utils/app_log.dart';

final groceriesProvider =
    StateNotifierProvider.family<
      GroceriesCountry,
      List<GroceriesCountryModel>?,
      String
    >((ref, id) {
      return GroceriesCountry(id);
    });

class GroceriesCountry extends StateNotifier<List<GroceriesCountryModel>?> {
  GroceriesCountry(String id) : super(null) {
    getCountry(id);
  }

  Future<void> getCountry(String id) async {
    try {
      final response = await HomeRepository.instance.countryData(id);
      state = response;
    } catch (e) {
      errorLog("country error is", e);
      state = [];
    }
  }
}
