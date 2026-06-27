class VendorTodayDashboardModel {
  final String storeName;
  final double totalEarnings;
  final List<EarningsOverTime> earningsOverTime;
  final int totalPendingOrders;
  final int totalProducts;
  final int totalFollowers;
  final String filterType;

  VendorTodayDashboardModel({
    required this.storeName,
    required this.totalEarnings,
    required this.earningsOverTime,
    required this.totalPendingOrders,
    required this.totalProducts,
    required this.totalFollowers,
    required this.filterType,
  });

  factory VendorTodayDashboardModel.fromJson(Map<String, dynamic> json) {
    return VendorTodayDashboardModel(
      storeName: "${json['storeName'] ?? ''}",
      totalEarnings:
      double.tryParse("${json['totalEarnings'] ?? 0}") ?? 0.0,
      earningsOverTime: json['earningsOverTime'] is List
          ? (json['earningsOverTime'] as List<dynamic>? ?? [])
          .map((e) => EarningsOverTime.fromJson(e))
          .toList()
          : [],
      totalPendingOrders:
      int.tryParse("${json['totalPendingOrders'] ?? 0}") ?? 0,
      totalProducts:
      int.tryParse("${json['totalProducts'] ?? 0}") ?? 0,
      totalFollowers:
      int.tryParse("${json['totalFollowers'] ?? 0}") ?? 0,
      filterType: "${json['filterType'] ?? ''}",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeName': storeName,
      'totalEarnings': totalEarnings,
      'earningsOverTime':
      earningsOverTime.map((e) => e.toJson()).toList(),
      'totalPendingOrders': totalPendingOrders,
      'totalProducts': totalProducts,
      'totalFollowers': totalFollowers,
      'filterType': filterType,
    };
  }
}

class EarningsOverTime {
  final String day;
  final double earnings;

  EarningsOverTime({
    required this.day,
    required this.earnings,
  });

  factory EarningsOverTime.fromJson(Map<String, dynamic> json) {
    return EarningsOverTime(
      day: "${json['day'] ?? ''}",
      earnings: double.tryParse("${json['earnings'] ?? 0}") ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'earnings': earnings,
    };
  }
}