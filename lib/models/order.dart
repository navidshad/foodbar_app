import './models.dart';

class Order extends Cart {
  DateTime date;

  Order({double deliveryCharges, List<OrderedFood> foods, this.date})
      : super(deliveryCharges: deliveryCharges, foods: foods);

  factory Order.fromMap(Map detail) {
    
  }
}
