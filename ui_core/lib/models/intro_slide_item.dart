
import 'package:foodbar_flutter_core/mongodb/field.dart';
import 'package:foodbar_flutter_core/models/models.dart';

class IntroSlideItem  {
  String title;
  String description;
  ImageDetail image;
  bool alwaysShow;

  IntroSlideItem({this.title, this.description, this.alwaysShow, this.image});

  factory IntroSlideItem.fromMap(Map detail, {String host}) {
    return IntroSlideItem(
      title: detail['title'],
      description: detail['description'],
      alwaysShow: detail['alwaysShow'],
      image: ImageDetail(
        detail['image'],
        host: host,
        db: 'cms',
        collection: 'introSlider',
        id: detail['_id'],
      ),
    );
  }

  static List<DbField> getDbFields() {
    return [
      DbField('title'),
      DbField('description', fieldType: FieldType.textbox),
      DbField('alwaysShow', fieldType: FieldType.checkbox, dataType: DataType.bool),
      DbField('image', dataType: DataType.object, fieldType: FieldType.image),
    ];
  }
}
