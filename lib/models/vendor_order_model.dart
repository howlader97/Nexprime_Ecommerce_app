class VendorOrderModel {
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
  final String? courierName;
  final String? trackingUrl;
  final List<OrderItem> orderItems;
  final OrderInfo? order;
  final DateTime createdAt;
  final DateTime updatedAt;

  VendorOrderModel({
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
    this.courierName,
    this.trackingUrl,
    required this.orderItems,
    this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VendorOrderModel.fromJson(Map<String, dynamic> json) =>
      VendorOrderModel(
        id: json['id'],
        orderId: json['orderId'],
        storeId: json['storeId'],
        subTotal: (json['subTotal'] as num).toDouble(),
        commissionAmount: (json['commissionAmount'] as num).toDouble(),
        vendorEarnings: (json['vendorEarnings'] as num).toDouble(),
        isFulfield: json['isFulfield'] ?? false,
        isComplete: json['isComplete'] ?? false,
        isArchive: json['isArchive'] ?? false,
        trackingNumber: json['trackingNumber'],
        courierName: json['courierName'],
        trackingUrl: json['trackingUrl'],
        orderItems: (json['orderItems'] as List)
            .map((x) => OrderItem.fromJson(x))
            .toList(),
        order: json['order'] != null ? OrderInfo.fromJson(json['order']) : null,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
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
    'orderItems': orderItems.map((x) => x.toJson()).toList(),
    'order': order?.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

class OrderItem {
  final int? id;
  final int? productId;
  final int? quantity;
  final double? price;
  final String? productName;
  final int? subOrderId;
  final Product? product;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderItem({
    this.id,
    this.productId,
    this.quantity,
    this.price,
    this.productName,
    this.subOrderId,
    this.product,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json['id'],
    productId: json['productId'],
    quantity: json['quantity'],
    price: json['price'] != null ? (json['price'] as num).toDouble() : null,
    productName: json['productName'],
    subOrderId: json['subOrderId'],
    product: json['product'] != null ? Product.fromJson(json['product']) : null,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null,
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': productId,
    'quantity': quantity,
    'price': price,
    'productName': productName,
    'subOrderId': subOrderId,
    'product': product?.toJson(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
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

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    images: json['images'] != null ? List<String>.from(json['images']) : [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'images': images,
  };
}

class OrderInfo {
  final int id;
  final double totalAmount;
  final bool isPaid;
  final String status;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DeliveryAddress? deliveryAddress;
  final CustomerUser? user;

  OrderInfo({
    required this.id,
    required this.totalAmount,
    required this.isPaid,
    required this.status,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.deliveryAddress,
    this.user,
  });

  factory OrderInfo.fromJson(Map<String, dynamic> json) => OrderInfo(
    id: json['id'],
    totalAmount: (json['totalAmount'] as num).toDouble(),
    isPaid: json['isPaid'] ?? false,
    status: json['status'],
    userId: json['userId'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    deliveryAddress: json['deliveryAddress'] != null
        ? DeliveryAddress.fromJson(json['deliveryAddress'])
        : null,
    user: json['user'] != null ? CustomerUser.fromJson(json['user']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'totalAmount': totalAmount,
    'isPaid': isPaid,
    'status': status,
    'userId': userId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'deliveryAddress': deliveryAddress?.toJson(),
    'user': user?.toJson(),
  };
}

class DeliveryAddress {
  final int id;
  final int userId;
  final String fullName;
  final String postcode;
  final String fullAddress;
  final String buildingNameRoomNumber;
  final String phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  DeliveryAddress({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.postcode,
    required this.fullAddress,
    required this.buildingNameRoomNumber,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) => DeliveryAddress(
    id: json['id'],
    userId: json['userId'],
    fullName: json['fullName'],
    postcode: json['postcode'],
    fullAddress: json['fullAddress'],
    buildingNameRoomNumber: json['buildingNameRoomNumber'],
    phoneNumber: json['phoneNumber'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'fullName': fullName,
    'postcode': postcode,
    'fullAddress': fullAddress,
    'buildingNameRoomNumber': buildingNameRoomNumber,
    'phoneNumber': phoneNumber,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

class CustomerUser {
  final int id;
  final String fullname;
  final String email;
  final String phonenumber;
  final bool isVerified;
  final String? profileImageUrl;
  final String? residentcardFrontside;
  final String? residentcardBackside;
  final DateTime createdAt;
  final DateTime updatedAt;

  CustomerUser({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phonenumber,
    required this.isVerified,
    this.profileImageUrl,
    this.residentcardFrontside,
    this.residentcardBackside,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerUser.fromJson(Map<String, dynamic> json) => CustomerUser(
    id: json['id'],
    fullname: json['fullname'],
    email: json['email'],
    phonenumber: json['phonenumber'],
    isVerified: json['is_verified'] ?? false,
    profileImageUrl: json['profileImageUrl'],
    residentcardFrontside: json['residentcard_frontside'],
    residentcardBackside: json['residentcard_backside'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullname': fullname,
    'email': email,
    'phonenumber': phonenumber,
    'is_verified': isVerified,
    'profileImageUrl': profileImageUrl,
    'residentcard_frontside': residentcardFrontside,
    'residentcard_backside': residentcardBackside,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
