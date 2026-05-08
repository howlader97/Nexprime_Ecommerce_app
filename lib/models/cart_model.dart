class CartModel {
  final List<CartItem> items;
  final int totalItems;
  final double totalAmount;

  CartModel({
    required this.items,
    required this.totalItems,
    required this.totalAmount,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    items: List<CartItem>.from(
        json['items'].map((x) => CartItem.fromJson(x))),
    totalItems: json['totalItems'],
    totalAmount: (json['totalAmount'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'items': items.map((x) => x.toJson()).toList(),
    'totalItems': totalItems,
    'totalAmount': totalAmount,
  };
}

class CartItem {
  final int id;
  final int userId;
  final int productId;
  final int quantity;
  final Product product;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.product,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id'],
    userId: json['userId'],
    productId: json['productId'],
    quantity: json['quantity'],
    product: Product.fromJson(json['product']),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'productId': productId,
    'quantity': quantity,
    'product': product.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

class Product {
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
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    basePrice: (json['basePrice'] as num).toDouble(),
    stockUnits: json['stockUnits'],
    size: List<String>.from(json['size']),
    colors: List<String>.from(json['colors']),
    isDiscountSale: json['isDiscountSale'],
    salePrice: (json['salePrice'] as num).toDouble(),
    discountPercentage: (json['discountPercentage'] as num).toDouble(),
    shippingResponsibility: json['shippingResponsibility'],
    shippingCharge: (json['shippingCharge'] as num).toDouble(),
    totalPayableAmount: (json['total_payable_amount'] as num).toDouble(),
    images: List<String>.from(json['images']),
    storeId: json['storeId'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'basePrice': basePrice,
    'stockUnits': stockUnits,
    'size': size,
    'colors': colors,
    'isDiscountSale': isDiscountSale,
    'salePrice': salePrice,
    'discountPercentage': discountPercentage,
    'shippingResponsibility': shippingResponsibility,
    'shippingCharge': shippingCharge,
    'total_payable_amount': totalPayableAmount,
    'images': images,
    'storeId': storeId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
