
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/models/product_quantity_model.dart';

final productQuantityProvider= StateNotifierProvider<ProductQuantityProvider,ProductQuantityModel>(
    (ref) => ProductQuantityProvider(),
);

class ProductQuantityProvider extends StateNotifier<ProductQuantityModel>{
  ProductQuantityProvider()
  : super(ProductQuantityModel(quantity: 0, price: 180));

  void increment(){
    state =state.copyWith(
      quantity: state.quantity +1
    );
  }

  void decrement() {
    if (state.quantity > 1) {
      state = state.copyWith(quantity: state.quantity - 1);
    }
  }
  }