import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/models/banner_model.dart';
import 'package:nexprime/models/groceries_country_model.dart';
import 'package:nexprime/models/product_model.dart';
import 'package:nexprime/models/store_model.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/utils/app_log.dart';

class HomeRepository {
  /////////////// constructor
  HomeRepository._privateConstructor();

  static final HomeRepository _instance = HomeRepository._privateConstructor();

  static HomeRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;


  Future<ProductModel?> discountProduct() async {
    try {
      var response = await _apiServices.getServices(
        _api.discountProduct,
      );

      if (response != null && response is Map<String, dynamic>) {
        if(response.isNotEmpty){
          return ProductModel.fromJson(response);
        }

      }


    } catch (e) {
      errorLog("discount product data", e);

    }
    return null;
  }

  Future<List<BannerModel>> bannerData() async {
    try {
      var response = await _apiServices.getServices(_api.banners);
      if (response != null && response is List) {
        return response.map((e) => BannerModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      errorLog("banners data", e);
      return [];
    }
  }

  Future<List<GroceriesCountryModel>> countryData(String id) async {
    try {
      var response = await _apiServices.getServices(_api.groceriesCountry(id));
      if (response != null && response is List) {
        return response.map((e) => GroceriesCountryModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      errorLog("country data", e);
      return [];
    }
  }

  Future<List<StoreModel>> fetchStores() async {
    try {
      var response = await _apiServices.getServices(_api.stores);
      if (response != null && response is List) {
        return response.map((e) => StoreModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      errorLog("stores data", e);
      return [];
    }
  }

}
