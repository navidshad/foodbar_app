import './food.dart';

class Cart {
  List<Food> foods = [];

  double deliveryChages;

  double get itemTotal {
    double totalItemPrice = 0;
    foods.forEach((f) => totalItemPrice += f.price);
    return totalItemPrice;
  }

  double get total {
    double totalPrice = itemTotal + deliveryChages;
    return totalPrice;
  }

  Cart({this.deliveryChages=0});
}
