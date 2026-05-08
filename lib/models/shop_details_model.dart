import 'package:nexprime/models/product_model.dart';

class StoreDetailsModel {
  final int id;
  final String name;
  final String bio;
  final String address;
  final String photo;
  final String? coverImgUrl;
  final int vendorId;
  final VendorModel? vendor;
  final List<ProductModel> products;
  final int followerCount;
  final bool isFollowing;
  final DateTime createdAt;
  final DateTime updatedAt;

  StoreDetailsModel({
    required this.id,
    required this.name,
    required this.bio,
    required this.address,
    required this.photo,
    this.coverImgUrl,
    required this.vendorId,
    this.vendor,
    required this.products,
    required this.followerCount,
    required this.isFollowing,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StoreDetailsModel.fromJson(Map<String, dynamic> json) =>
      StoreDetailsModel(
        id: json['id'],
        name: json['name'],
        bio: json['bio'],
        address: json['address'],
        photo: json['photo'],
        coverImgUrl: json['coverImgUrl'],
        vendorId: json['vendorId'],
        vendor: json['vendor'] != null
            ? VendorModel.fromJson(json['vendor'])
            : null,
        products: json['products'] != null
            ? List<ProductModel>.from(
                json['products'].map((x) => ProductModel.fromJson(x)),
              )
            : [],
        followerCount: json['followerCount'] ?? 0,
        isFollowing: json['isFollowing'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'bio': bio,
    'address': address,
    'photo': photo,
    'coverImgUrl': coverImgUrl,
    'vendorId': vendorId,
    'vendor': vendor?.toJson(),
    'followerCount': followerCount,
    'isFollowing': isFollowing,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  StoreDetailsModel copyWith({
    int? id,
    String? name,
    String? bio,
    String? address,
    String? photo,
    String? coverImgUrl,
    int? vendorId,
    VendorModel? vendor,
    List<ProductModel>? products,
    int? followerCount,
    bool? isFollowing,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoreDetailsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      address: address ?? this.address,
      photo: photo ?? this.photo,
      coverImgUrl: coverImgUrl ?? this.coverImgUrl,
      vendorId: vendorId ?? this.vendorId,
      vendor: vendor ?? this.vendor,
      products: products ?? this.products,
      followerCount: followerCount ?? this.followerCount,
      isFollowing: isFollowing ?? this.isFollowing,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Vendor model
class VendorModel {
  final int id;
  final String fullname;
  final String email;
  final String phonenumber;

  VendorModel({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phonenumber,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
    id: json['id'],
    fullname: json['fullname'],
    email: json['email'],
    phonenumber: json['phonenumber'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullname': fullname,
    'email': email,
    'phonenumber': phonenumber,
  };
}
