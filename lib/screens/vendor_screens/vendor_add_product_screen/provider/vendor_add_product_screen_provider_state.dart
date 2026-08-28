import 'dart:io';

class VendorAddProductScreenProviderState {
  final String foodType;
  final int? selectedFoodTypeId;
  final String category;
  final int? selectedCategoryId;
  final bool isAvailable;
  final bool isGrocery;
  final bool isDiscountSale;
  final String shippingResponsibility;
  final List<File> images;
  final bool isLoading;

  VendorAddProductScreenProviderState({
    this.foodType = "",
    this.selectedFoodTypeId,
    this.category = "",
    this.selectedCategoryId,
    this.isAvailable = false,
    this.isGrocery = true,
    this.isDiscountSale = false,
    this.shippingResponsibility = "VENDOR",
    this.images = const [],
    this.isLoading = false,
  });

  VendorAddProductScreenProviderState copyWith({
    String? foodType,
    int? selectedFoodTypeId,
    String? category,
    int? selectedCategoryId,
    bool? isAvailable,
    bool? isGrocery,
    bool? isDiscountSale,
    String? shippingResponsibility,
    List<File>? images,
    bool? isLoading,
  }) {
    return VendorAddProductScreenProviderState(
      foodType: foodType ?? this.foodType,
      selectedFoodTypeId: selectedFoodTypeId ?? this.selectedFoodTypeId,
      category: category ?? this.category,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      isAvailable: isAvailable ?? this.isAvailable,
      isGrocery: isGrocery ?? this.isGrocery,
      isDiscountSale: isDiscountSale ?? this.isDiscountSale,
      shippingResponsibility:
          shippingResponsibility ?? this.shippingResponsibility,
      images: images ?? this.images,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}