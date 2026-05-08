class GroceriesCountryModel {
  final String name;
  final String image;
  final int id;
  final int mainCategoryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  GroceriesCountryModel({
    required this.name,
    required this.image,
    required this.id,
    required this.mainCategoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GroceriesCountryModel.fromJson(Map<String, dynamic> json) {
    return GroceriesCountryModel(
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      mainCategoryId: int.tryParse(json['mainCategoryId']?.toString() ?? '0') ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now() : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now() : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'id': id,
      'mainCategoryId': mainCategoryId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// copyWith method
  GroceriesCountryModel copyWith({
    String? name,
    String? image,
    int? id,
    int? mainCategoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GroceriesCountryModel(
      name: name ?? this.name,
      image: image ?? this.image,
      id: id ?? this.id,
      mainCategoryId: mainCategoryId ?? this.mainCategoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Helper for list parsing
  static List<GroceriesCountryModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => GroceriesCountryModel.fromJson(e)).toList();
  }
}