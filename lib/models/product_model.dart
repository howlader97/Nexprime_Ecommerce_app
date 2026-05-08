class ProductModel {
  final int id;
  final String name;
  final String description;
  final double basePrice;
  final int stockUnits;
  final List<String> size;
  final List<String> colors;
  final bool isDiscountSale;
  final double salePrice;
  final double discountPercentage;
  final String shippingResponsibility;
  final double shippingCharge;
  final double totalPayableAmount;
  final List<String> images;
  final int storeId;
  final Store store;
  final List<Category> categories;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.stockUnits,
    required this.size,
    required this.colors,
    required this.isDiscountSale,
    required this.salePrice,
    required this.discountPercentage,
    required this.shippingResponsibility,
    required this.shippingCharge,
    required this.totalPayableAmount,
    required this.images,
    required this.storeId,
    required this.store,
    required this.categories,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      basePrice: (json['basePrice'] ?? 0).toDouble(),
      stockUnits: json['stockUnits'] ?? 0,
      size: List<String>.from(json['size'] ?? []),
      colors: List<String>.from(json['colors'] ?? []),
      isDiscountSale: json['isDiscountSale'] ?? false,
      salePrice: (json['salePrice'] ?? 0).toDouble(),
      discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
      shippingResponsibility: json['shippingResponsibility'] ?? "",
      shippingCharge: (json['shippingCharge'] ?? 0).toDouble(),
      totalPayableAmount: (json['total_payable_amount'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      storeId: json['storeId'] ?? 0,
      store:  json['store'] != null
          ? Store.fromJson(json['store'])
          : Store(
        id: 0,
        name: "",
        address: "",
        photo: "",
      ),
      categories: (json['categories'] as List? ?? [])
          .map((e) => Category.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Store {
  final int id;
  final String name;
  final String address;
  final String photo;
  final String? coverImgUrl;

  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.photo,
    this.coverImgUrl,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      address: json['address'] ?? "",
      photo: json['photo'] ?? "",
      coverImgUrl: json['coverImgUrl'],
    );
  }
}

class Category {
  final int id;
  final String name;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      image: json['image'] ?? "",
    );
  }
}