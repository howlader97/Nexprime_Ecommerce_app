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
  final List<OrderItem> orderItems;
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
    required this.orderItems,
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
        orderItems: (json['orderItems'] as List)
            .map((x) => OrderItem.fromJson(x))
            .toList(),
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
    'orderItems': orderItems.map((x) => x.toJson()).toList(),
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
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderItem({
    this.id,
    this.productId,
    this.quantity,
    this.price,
    this.productName,
    this.subOrderId,
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
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}
