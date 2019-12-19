import 'package:meta/meta.dart';

import 'package:Food_Bar/models/models.dart';

@immutable
abstract class CartEvent {}

class GetCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final Food food;
  AddToCartEvent(this.food);
}

class RemovefromCatEvent extends CartEvent {
  final Food food;
  RemovefromCatEvent(this.food);
}
