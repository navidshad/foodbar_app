import './food.dart';

class OrderedFood extends Food {
  int total;

  double get totalPrice => this.price * total;

  // his code is used when a copy of this object wants to update 
  // this object at cart food list.
  // this hashcode being given when this object is about to be a refrence;
  int initialHash;

  OrderedFood({
    String id,
    String categoryId,
    String title,
    String subTitle,
    String description,
    String imageUrl,
    double price,
    this.total,
  }) : super(
          id: id,
          categoryId: categoryId,
          title: title,
          subTitle: subTitle,
          description: description,
          imageUrl: imageUrl,
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
      imageUrl: food.imageUrl,
      price: food.price,
    );
  }
}
