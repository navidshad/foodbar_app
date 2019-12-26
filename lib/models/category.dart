import './food.dart';

class Category {
  String id;
  String title;
  String description;
  String imageUrl;

  Category({this.id, this.title, this.description, this.imageUrl});

  factory Category.fromMap(Map detail) {
    return Category(
        id: detail['_id'],
        title: detail['title'],
        description: detail['description'],
        imageUrl: detail['imageUrl']);
  }

  String getCombinedTag() => '#$id-$imageUrl';
}

class CategoryWithFoods extends Category {
  List<Food> foods = [];

  CategoryWithFoods({String id, String title, String description, this.foods})
      : super(id: id, title: title, description: description);

  factory CategoryWithFoods.fromCategory(Category cat){
    return CategoryWithFoods(id:cat.id, title: cat.title, description: cat.description, foods: []);
  }
}
