class BannerModel {
  final String link;
  final int id;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  BannerModel({
    required this.link,
    required this.id,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      link: json['link'] ?? '',
      id: json['id'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'link': link,
      'id': id,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}