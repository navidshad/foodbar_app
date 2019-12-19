import 'package:meta/meta.dart';

import 'package:Food_Bar/models/models.dart';

@immutable
abstract class CartState {}
  
// class InitialCartState extends CartState {
//   final Cart cart;
//   InitialCartState(this.cart);
// }

class ShowCartState extends CartState {
  final Cart cart;
  ShowCartState(this.cart);
}

class ShowFoodCountCartState extends CartState {
  final int count;
  ShowFoodCountCartState(this.count);
}
