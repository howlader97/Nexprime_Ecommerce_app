class VendorDashboardModel {
  final String storeName;
  final double totalEarnings;
  final List<Last7DaysEarnings> last7DaysEarnings;
  final int totalPendingOrders;
  final int totalProducts;
  final double totalFollowers;

  VendorDashboardModel({
    required this.storeName,
    required this.totalEarnings,
    required this.last7DaysEarnings,
    required this.totalPendingOrders,
    required this.totalProducts,
    required this.totalFollowers,
  });

  factory VendorDashboardModel.fromJson(Map<String, dynamic> json) {
    return VendorDashboardModel(
      storeName: json['storeName'] ?? '',
      totalEarnings: (json['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      last7DaysEarnings: (json['last7DaysEarnings'] as List?)
          ?.map((e) => Last7DaysEarnings.fromJson(e))
          .toList() ??
          [],
      totalPendingOrders: json['totalPendingOrders'] ?? 0,
      totalProducts: json['totalProducts'] ?? 0,
      totalFollowers: (json['totalFollowers'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeName': storeName,
      'totalEarnings': totalEarnings,
      'last7DaysEarnings':
      last7DaysEarnings.map((e) => e.toJson()).toList(),
      'totalPendingOrders': totalPendingOrders,
      'totalProducts': totalProducts,
      'totalFollowers': totalFollowers,
    };
  }
}

class Last7DaysEarnings {
  final String day;
  final double earnings;

  Last7DaysEarnings({
    required this.day,
    required this.earnings,
  });

  factory Last7DaysEarnings.fromJson(Map<String, dynamic> json) {
    return Last7DaysEarnings(
      day: json['day'] ?? '',
      earnings: (json['earnings'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'earnings': earnings,
    };
  }
}