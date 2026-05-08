class ReviewModel {
  final int id;
  final int score;
  final String review;
  final int productId;
  final int orderId;
  final int userId;
  final ReviewUser user;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReviewModel({
    required this.id,
    required this.score,
    required this.review,
    required this.productId,
    required this.orderId,
    required this.userId,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? 0,
      score: json['score'] ?? 0,
      review: json['review'] ?? '',
      productId: json['productId'] ?? 0,
      orderId: json['orderId'] ?? 0,
      userId: json['userId'] ?? 0,
      user: ReviewUser.fromJson(json['user'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'score': score,
      'review': review,
      'productId': productId,
      'orderId': orderId,
      'userId': userId,
      'user': user.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ReviewUser {
  final int id;
  final String fullname;
  final String profileImageUrl;

  ReviewUser({
    required this.id,
    required this.fullname,
    required this.profileImageUrl,
  });

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: json['id'] ?? 0,
      fullname: json['fullname'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'profileImageUrl': profileImageUrl,
    };
  }
}