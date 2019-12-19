import 'package:Food_Bar/models/models.dart';

class OrderService {
  Cart _cart = Cart();

  Cart get cart => _cart;

  void addToCart(Food food) {
    _cart.foods.add(food);
  }

  void removeFromCart(Food food)
  {
    _cart.foods.remove(food);
  }
}
