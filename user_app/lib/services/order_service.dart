import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_user/settings/app_properties.dart';

class OrderService {

  OrderService.privateConstructor();
  static final instace = OrderService.privateConstructor();
  
  Cart _cart = Cart();

  Cart get cart => _cart;

  void addToCart(OrderedFood orderedfood) {
    // set intial hashcode
    orderedfood.initialHash = orderedfood.hashCode;
    _cart.foods.add(orderedfood);
  }

  void updateCart(OrderedFood orderedfood) {
    int index = _cart.foods.indexWhere((f) => (f.initialHash == orderedfood.initialHash));
    if(index > -1) _cart.foods[index] = orderedfood;
  }

  void removeFromCart(Food food)
  {
    _cart.foods.remove(food);
  }
}
