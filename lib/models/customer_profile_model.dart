class CustomerProfileModel {
  final int id;
  final String fullname;
  final String email;
  final String phonenumber;
  final String role;
  final String status;
  final String? profileImageUrl;
  final String? coverImageUrl;
  final bool isVerified;
  final String residentcardFrontside;
  final String residentcardBackside;
  final DateTime createdAt;
  final String? locaion;

  CustomerProfileModel({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phonenumber,
    required this.role,
    required this.status,
    this.profileImageUrl,
    this.coverImageUrl,
    required this.isVerified,
    required this.residentcardFrontside,
    required this.residentcardBackside,
    required this.createdAt,
    this.locaion
  });

  factory CustomerProfileModel.fromJson(Map<String, dynamic> json) {
    return CustomerProfileModel(
      id: json['id'],
      fullname: json['fullname'],
      email: json['email'],
      phonenumber: json['phonenumber'],
      role: json['role'],
      status: json['status'],
      profileImageUrl: json['profileImageUrl'],
      coverImageUrl: json['coverImageUrl'],
      isVerified: json['is_verified'],
      residentcardFrontside: json['residentcard_frontside'],
      residentcardBackside: json['residentcard_backside'],
      createdAt: DateTime.parse(json['createdAt']),
      locaion: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'phonenumber': phonenumber,
      'role': role,
      'status': status,
      'profileImageUrl': profileImageUrl,
      'coverImageUrl': coverImageUrl,
      'is_verified': isVerified,
      'residentcard_frontside': residentcardFrontside,
      'residentcard_backside': residentcardBackside,
      'createdAt': createdAt.toIso8601String(),
      'location' : locaion,
    };
  }
}