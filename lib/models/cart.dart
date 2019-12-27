import 'package:Food_Bar/models/models.dart';

class Cart {
  List<OrderedFood> foods = [];

  double deliveryChages;

  double get itemTotal {
    double totalItemPrice = 0;
    foods.forEach((f) => totalItemPrice += f.price*f.total);
    return totalItemPrice;
  }

  double get total {
    double totalPrice = itemTotal + deliveryChages;
    return (itemTotal > 0) ? totalPrice : 0;
  }

  Cart({this.deliveryChages=0});
}
