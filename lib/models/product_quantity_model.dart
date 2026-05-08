class ProductQuantityModel {
  final int quantity;
  final double price;

  ProductQuantityModel({required this.quantity, required this.price});

  double get totalPrice => price * quantity;

  ProductQuantityModel copyWith({double? price, int? quantity}) {
    return ProductQuantityModel(
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}
