class FollowStoreModel {
  final int id;
  final String name;
  final String bio;
  final String address;
  final String photo;
  final String? coverImgUrl;
  final int vendorId;
  final Vendor vendor;
  final List<dynamic> products;
  final int followerCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  FollowStoreModel({
    required this.id,
    required this.name,
    required this.bio,
    required this.address,
    required this.photo,
    this.coverImgUrl,
    required this.vendorId,
    required this.vendor,
    required this.products,
    required this.followerCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FollowStoreModel.fromJson(Map<String, dynamic> json) {
    return FollowStoreModel(
      id: json['id'],
      name: json['name']?.toString() ?? '',
      bio: json['bio'] ?? '',
      address: json['address'] ?? '',
      photo: json['photo'] ?? '',
      coverImgUrl: json['coverImgUrl'] ?? '',
      vendorId: int.tryParse(json['vendorId']?.toString() ?? '') ?? 0,
      vendor: json['vendor'] != null
          ? Vendor.fromJson(json['vendor'])
          : Vendor(
        id: 0,
        fullname: '',
        email: '',
        phonenumber: '',
      ),
      products: json['products'] ?? [],
      followerCount: int.tryParse(json['followerCount']?.toString() ?? '') ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
      'vendor': vendor.toJson(),
      'products': products,
      'followerCount': followerCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
class Vendor {
  final int id;
  final String fullname;
  final String email;
  final String phonenumber;

  Vendor({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phonenumber,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'] ?? 0,
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'phonenumber': phonenumber,
    };
  }
}