import 'dart:io';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/screens/vendor_screens/vendor_add_product_screen/provider/vendor_add_product_screen_provider_state.dart';
import 'package:nexprime/services/repository/vendor_product_repository.dart';

final vendorAddProductScreenProvider = StateNotifierProvider(
  (ref) => _VendorAddProductScreenProvider(),
);

class _VendorAddProductScreenProvider
    extends StateNotifier<VendorAddProductScreenProviderState> {
  _VendorAddProductScreenProvider()
      : super(VendorAddProductScreenProviderState());

  void changeDropdown(String? value, int? id) {
    if (value != null) {
      state = state.copyWith(category: value, selectedCategoryId: id);
    }
  }

  void changeFoodTypeDropdown(String? value, int? id) {
    if (value != null) {
      state = state.copyWith(foodType: value, selectedFoodTypeId: id);
    }
  }

  void toggleCatalogType(bool value) {
    state = state.copyWith(
      isGrocery: value,
      category: "",
      selectedCategoryId: null,
      foodType: "",
      selectedFoodTypeId: null,
    );
  }

  void toggleAvailability(bool value) {
    state = state.copyWith(isAvailable: value);
  }

  void toggleDiscountSale(bool value) {
    state = state.copyWith(isDiscountSale: value);
  }

  void changeShippingResponsibility(String value) {
    state = state.copyWith(shippingResponsibility: value);
  }

  void addImage(File file) {
    state = state.copyWith(images: [...state.images, file]);
  }

  void removeImage(File file) {
    state = state.copyWith(
      images: state.images.where((e) => e.path != file.path).toList(),
    );
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  Future<bool> publishProduct(Map<String, dynamic> data) async {
    setLoading(true);
    bool success = await VendorProductRepository.instance.addProduct(data, state.images);
    setLoading(false);
    return success;
  }
}
