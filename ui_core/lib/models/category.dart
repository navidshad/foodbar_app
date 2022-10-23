import './food.dart';
import 'package:foodbar_flutter_core/mongodb/field.dart';

import 'image_detail.dart';

class Category {
  String id;
  String title;
  String description;
  ImageDetail? image;

  Category(
      {required this.id,
      required this.title,
      this.description = '',
      this.image});

  factory Category.fromMap(Map detail, {String host = ''}) {
    return Category(
        id: detail['_id'],
        title: detail['title'],
        description: detail['description'],
        image: ImageDetail(
          detail['image'],
          host: host,
          db: 'cms',
          collection: 'foodCategory',
          id: detail['_id'],
        ));
  }

  static List<DbField> getDbFields() {
    return [
      DbField('title'),
      DbField('description', fieldType: FieldType.textbox),
      DbField('image', dataType: DataType.object, fieldType: FieldType.image),
    ];
  }

  String getCombinedTag() => '#$id-${image!.getUrl()}';
}

class CategoryWithFoods extends Category {
  List<Food> foods = [];

  CategoryWithFoods({
    required String id,
    required String title,
    String description = '',
    ImageDetail? image,
    this.foods = const [],
  }) : super(id: id, title: title, description: description, image: image);

  factory CategoryWithFoods.fromCategory(Category cat,
      {List<Food> foods = const []}) {
    return CategoryWithFoods(
        id: cat.id,
        title: cat.title,
        description: cat.description,
        image: cat.image,
        foods: foods);
  }
}
