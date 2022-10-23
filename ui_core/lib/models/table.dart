import 'package:foodbar_flutter_core/mongodb/field.dart';
import './image_detail.dart';

class CustomTable {
  String id;
  String title;
  ImageDetail? image;
  int persons;

  CustomTable({
    required this.id,
    this.title = '',
    this.persons = 1,
    this.image,
  });

  factory CustomTable.fromMap(Map detail, {String host = ''}) {
    CustomTable table = CustomTable(id: '');

    if (detail['type'] == 'Board') {
      table = BoardTable(
        id: detail['_id'],
        count: detail['count'],
        image: ImageDetail(
          detail['image'],
          host: host,
          db: 'cms',
          collection: 'table',
          id: detail['_id'],
        ),
        persons: detail['persons'],
        title: detail['title'],
      );
    } else if (detail['type'] == 'RollBand') {
      table = RollBandTable(
        id: detail['_id'],
        image: ImageDetail(
          detail['image'],
          host: host,
          db: 'cms',
          collection: 'table',
          id: detail['_id'],
        ),
        persons: detail['persons'],
        title: detail['title'],
      );
    }

    return table;
  }

  static List<DbField> getDbFields() {
    return [
      DbField('title'),
      DbField('type',
          dataType: DataType.string,
          fieldType: FieldType.select,
          subFields: [
            DbField('Board'),
            DbField('RollBand', customTitle: 'Roll Band')
          ]),
      DbField('persons', dataType: DataType.int),
      DbField('count', dataType: DataType.int),
      DbField('image', dataType: DataType.object, fieldType: FieldType.image),
    ];
  }
}

class BoardTable extends CustomTable {
  int count;

  BoardTable({
    int persons = 1,
    this.count = 10,
    String title = '',
    ImageDetail? image,
    required String id,
  }) : super(id: id, title: title, image: image, persons: persons);
}

class RollBandTable extends CustomTable {
  RollBandTable({
    int persons = 1,
    String title = '',
    ImageDetail? image,
    required String id,
  }) : super(id: id, title: title, image: image, persons: persons);
}
