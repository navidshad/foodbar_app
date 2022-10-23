import 'package:foodbar_flutter_core/mongodb/field.dart';
import './category.dart';
import './image_detail.dart';

class Food {
  String id;
  String categoryId;
  String title;
  String subTitle;
  String description;
  ImageDetail? image;
  double price;

  Food({
    required this.id,
    required this.categoryId,
    required this.title,
    this.subTitle = '',
    this.description = '',
    this.price = 0,
    this.image,
  });

  factory Food.fromMap(Map detail, {String host = ''}) {
    Food food = Food(id: '', categoryId: '', title: '');

    try {
      food = Food(
          id: detail['_id'],
          title: detail['title'],
          subTitle: detail['subTitle'],
          description: detail['description'],
          categoryId: detail['category'],
          image: ImageDetail(
            detail['image'],
            host: host,
            db: 'cms',
            collection: 'food',
            id: detail['_id'],
          ),
          price: double.parse(detail['price'].toString()));
    } catch (e) {
      print('Food.fromMap error $e');
    }
    return food;
  }

  static List<DbField> getDbFields() {
    return [
      DbField('title'),
      DbField('subTitle'),
      DbField('description', fieldType: FieldType.textbox),
      DbField('category', fieldType: FieldType.select, subFields: []),
      DbField('price', fieldType: FieldType.number, dataType: DataType.float),
      DbField('image', dataType: DataType.object, fieldType: FieldType.image),
    ];
  }

  String getCombinedTag() => '#$id-${image!.getUrl()}';
}
