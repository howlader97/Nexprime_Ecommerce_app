class StoreModel {
  final int id;
  final String name;
  final String? bio;
  final String? address;
  final String? photo;
  final String? coverImgUrl;
  final int? vendorId;
  final int? followerCount;

  StoreModel({
    required this.id,
    required this.name,
    this.bio,
    this.address,
    this.photo,
    this.coverImgUrl,
    this.vendorId,
    this.followerCount,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      bio: json['bio'],
      address: json['address'],
      photo: json['photo'],
      coverImgUrl: json['coverImgUrl'],
      vendorId: json['vendorId'],
      followerCount: json['followerCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'address': address,
      'photo': photo,
      'coverImgUrl': coverImgUrl,
      'vendorId': vendorId,
      'followerCount': followerCount,
    };
  }

  static List<StoreModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => StoreModel.fromJson(e)).toList();
  }
}
