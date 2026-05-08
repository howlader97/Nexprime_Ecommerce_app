import 'package:nexprime/models/product_model.dart';

class VendorStoreModel {
  final int id;
  final String name;
  final String? bio;
  final String? address;
  final String? photo;
  final String? coverImgUrl;
  final int vendorId;
  final String createdAt;
  final String updatedAt;
  final int followerCount;
  final int followers;
  final List<ProductModel> products;

  VendorStoreModel({
    required this.id,
    required this.name,
    this.bio,
    this.address,
    this.photo,
    this.coverImgUrl,
    required this.vendorId,
    required this.createdAt,
    required this.updatedAt,
    required this.followerCount,
    required this.followers,
    required this.products,
  });

  factory VendorStoreModel.fromJson(Map<String, dynamic> json) {
    return VendorStoreModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      bio: json['bio'],
      address: json['address'],
      photo: json['photo'],
      coverImgUrl: json['coverImgUrl'],
      vendorId: json['vendorId'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      followerCount: json['followerCount'] ?? 0,
      followers: json['followers'] ?? 0,
      products: (json['products'] as List? ?? [])
        .map((e) => ProductModel.fromJson(e))
        .toList(),
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'followerCount': followerCount,
      'followers' :followers
    };
  }
}
