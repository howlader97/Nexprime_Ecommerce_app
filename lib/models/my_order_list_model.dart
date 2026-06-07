class MyOrderListModel {
  final int id;
  final double totalAmount;
  final bool isPaid;
  final String status;
  final int deliveryAddressId;
  final DeliveryAddress deliveryAddress;
  final int userId;
  final List<SubOrder> subOrders;
  final DateTime createdAt;
  final DateTime updatedAt;

  MyOrderListModel({
    required this.id,
    required this.totalAmount,
    required this.isPaid,
    required this.status,
    required this.deliveryAddressId,
    required this.deliveryAddress,
    required this.userId,
    required this.subOrders,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MyOrderListModel.fromJson(Map<String, dynamic> json) {
    return MyOrderListModel(
      id: int.tryParse("${json['id'] ?? 0}") ?? 0,
      totalAmount: double.tryParse("${json['totalAmount'] ?? 0}") ?? 0.0,
      isPaid: json['isPaid'],
      status: "${json['status'] ?? ''}",
      deliveryAddressId: int.tryParse("${json['deliveryAddressId'] ?? 0}") ?? 0,
      deliveryAddress:
      DeliveryAddress.fromJson(json['deliveryAddress']),
      userId: int.tryParse("${json['userId'] ?? 0}") ?? 0,
      subOrders: json['subOrders'] is List ?(json['subOrders'] as List)
          .map((e) => SubOrder.fromJson(e))
          .toList(): [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalAmount': totalAmount,
      'isPaid': isPaid,
      'status': status,
      'deliveryAddressId': deliveryAddressId,
      'deliveryAddress': deliveryAddress.toJson(),
      'userId': userId,
      'subOrders': subOrders.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class DeliveryAddress {
  final String fullName;
  final String postcode;
  final String fullAddress;
  final String buildingNameRoomNumber;
  final String phoneNumber;
  final int id;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  DeliveryAddress({
    required this.fullName,
    required this.postcode,
    required this.fullAddress,
    required this.buildingNameRoomNumber,
    required this.phoneNumber,
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      fullName: "${json['fullName'] ?? ''}",
      postcode: "${json['postcode'] ?? ''}",
      fullAddress: "${json['fullAddress'] ?? ''}",
      buildingNameRoomNumber: "${json['buildingNameRoomNumber'] ?? ''}",
      phoneNumber: json['phoneNumber'],
      id: int.tryParse("${json['id'] ?? 0}") ?? 0,
      userId: int.tryParse("${json['userId'] ?? 0}") ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'postcode': postcode,
      'fullAddress': fullAddress,
      'buildingNameRoomNumber': buildingNameRoomNumber,
      'phoneNumber': phoneNumber,
      'id': id,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class SubOrder {
  final int id;
  final int orderId;
  final int storeId;
  final double subTotal;
  final double commissionAmount;
  final double vendorEarnings;
  final bool isFulfield;
  final bool isComplete;
  final bool isArchive;
  final String? trackingNumber;
  final String courierName;
  final String? trackingUrl;
  final List<OrderItem> orderItems;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubOrder({
    required this.id,
    required this.orderId,
    required this.storeId,
    required this.subTotal,
    required this.commissionAmount,
    required this.vendorEarnings,
    required this.isFulfield,
    required this.isComplete,
    required this.isArchive,
    this.trackingNumber,
    required this.courierName,
    this.trackingUrl,
    required this.orderItems,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubOrder.fromJson(Map<String, dynamic> json) {
    return SubOrder(
      id: int.tryParse("${ json['id'] ?? 0}") ?? 0,
      orderId: int.tryParse("${json['orderId'] ?? 0}") ?? 0,
      storeId: int.tryParse("${json['storeId'] ?? 0}") ?? 0,
      subTotal: double.tryParse("${json['subTotal'] ?? 0}") ?? 0.0,
      commissionAmount: double.tryParse("${json['commissionAmount'] ?? 0}") ?? 0.0,
      vendorEarnings: double.tryParse("${json['vendorEarnings'] ?? 0}") ?? 0.0,
      isFulfield: json['isFulfield'],
      isComplete: json['isComplete'],
      isArchive: json['isArchive'],
      trackingNumber: json['trackingNumber'],
      courierName: json['courierName'],
      trackingUrl: json['trackingUrl'],
      orderItems: json['orderItems'] is List ? (json['orderItems'] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList(): [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'storeId': storeId,
      'subTotal': subTotal,
      'commissionAmount': commissionAmount,
      'vendorEarnings': vendorEarnings,
      'isFulfield': isFulfield,
      'isComplete': isComplete,
      'isArchive': isArchive,
      'trackingNumber': trackingNumber,
      'courierName': courierName,
      'trackingUrl': trackingUrl,
      'orderItems': orderItems.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class OrderItem {
  final int productId;
  final int quantity;
  final double price;
  final int id;
  final int subOrderId;
  final Product product;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.id,
    required this.subOrderId,
    required this.product,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: int.tryParse("${json['productId'] ?? 0}") ?? 0,
      quantity: int.tryParse("${json['quantity'] ?? 0}") ?? 0,
      price: double.tryParse("${json['price'] ?? 0}") ?? 0.0,
      id: int.tryParse("${json['id'] ?? 0}") ?? 0,
      subOrderId: int.tryParse("${json['subOrderId'] ?? 0}") ?? 0,
      product: Product.fromJson(json['product']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'id': id,
      'subOrderId': subOrderId,
      'product': product.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Product {
  final int id;
  final String name;
  final List<String> images;

  Product({
    required this.id,
    required this.name,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse("${json['id'] ?? 0}") ?? 0,
      name: json['name'],
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'images': images,
    };
  }
}