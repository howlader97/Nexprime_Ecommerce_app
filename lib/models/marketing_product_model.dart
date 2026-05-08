class MarketingProductModel {
  int? id;
  String? name;
  String? goodsType;
  String? location;
  String? description;
  dynamic price;
  dynamic publishingFee;
  String? shippingResponsibility;
  dynamic shippingCharge;
  List<String>? images;
  int? creatorId;
  String? createdAt;
  String? updatedAt;
  Creator? creator;

  MarketingProductModel(
      {this.id,
      this.name,
      this.goodsType,
      this.location,
      this.description,
      this.price,
      this.publishingFee,
      this.shippingResponsibility,
      this.shippingCharge,
      this.images,
      this.creatorId,
      this.createdAt,
      this.updatedAt,
      this.creator});

  MarketingProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    goodsType = json['goodsType'];
    location = json['location'];
    description = json['description'];
    price = json['price'];
    publishingFee = json['publishingFee'];
    shippingResponsibility = json['shippingResponsibility'];
    shippingCharge = json['shippingCharge'];
    images = json['images']?.cast<String>();
    creatorId = json['creatorId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    creator =
        json['creator'] != null ? Creator.fromJson(json['creator']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['goodsType'] = goodsType;
    data['location'] = location;
    data['description'] = description;
    data['price'] = price;
    data['publishingFee'] = publishingFee;
    data['shippingResponsibility'] = shippingResponsibility;
    data['shippingCharge'] = shippingCharge;
    data['images'] = images;
    data['creatorId'] = creatorId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (creator != null) {
      data['creator'] = creator!.toJson();
    }
    return data;
  }
}

class Creator {
  int? id;
  String? fullname;
  String? email;
  String? profileImageUrl;
  String? phonenumber;

  Creator({this.id, this.fullname, this.email,this.profileImageUrl, this.phonenumber});

  Creator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    email = json['email'];
    profileImageUrl=json['profileImageUrl'];
    phonenumber = json['phonenumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullname'] = fullname;
    data['email'] = email;
    data['profileImageUrl'] =profileImageUrl;
    data['phonenumber'] = phonenumber;
    return data;
  }
}
