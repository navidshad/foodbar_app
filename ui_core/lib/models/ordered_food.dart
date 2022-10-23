import './food.dart';
import 'image_detail.dart';

class OrderedFood extends Food {
  int total;

  double get totalPrice => this.price * total;

  // this code is used when a copy of this object wants to update
  // this object at cart food list.
  // this hashcode being given when this object is about to be a refrence;
  int initialHash = 0;

  OrderedFood({
    required String id,
    required String categoryId,
    required String title,
    String subTitle = '',
    String description = '',
    ImageDetail? image,
    double price = 0,
    this.total = 0,
  }) : super(
          id: id,
          categoryId: categoryId,
          title: title,
          subTitle: subTitle,
          description: description,
          image: image,
          price: price,
        );

  factory OrderedFood.fromFood(Food food, {int total = 1}) {
    return OrderedFood(
      total: total,
      id: food.id,
      categoryId: food.categoryId,
      title: food.title,
      subTitle: food.subTitle,
      description: food.description,
      image: food.image,
      price: food.price,
    );
  }
}
