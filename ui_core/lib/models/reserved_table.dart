import 'package:foodbar_flutter_core/mongodb/field.dart';
import './image_detail.dart';

class ReservedTable {
  String id;
  String refId;
  String tableId;
  DateTime from;
  DateTime to;
  int persons;
  int totalPersonOnTable;
  int reservedId;
  ImageDetail? image;

  ReservedTable({
    required this.id,
    required this.refId,
    required this.tableId,
    required this.from,
    required this.to,
    this.persons = 1,
    required this.totalPersonOnTable,
    required this.reservedId,
    this.image,
  });

  int get totalTable {
    int tables = (persons / totalPersonOnTable).ceil();
    return tables == totalPersonOnTable ? 1 : tables;
  }

  factory ReservedTable.fromMap(Map detail, ImageDetail? image) {
    return ReservedTable(
        id: detail['_id'],
        refId: detail['refId'],
        tableId: detail['tableId'],
        from: DateTime.parse(detail['from']),
        to: DateTime.parse(detail['to']),
        persons: detail['persons'],
        totalPersonOnTable: detail['totalPersonOnTable'],
        reservedId: detail['reservedId'],
        image: image);
  }

  static List<DbField> getDbFields() {
    return [
      DbField('refId', isHide: true),
      DbField('from', dataType: DataType.dateTime),
      DbField('to', dataType: DataType.dateTime),
      DbField('tableId', fieldType: FieldType.select),
      DbField('persons', dataType: DataType.int),
      DbField('totalPersonOnTable', dataType: DataType.int, isDisable: true),
      DbField('reservedId', dataType: DataType.int, isDisable: true),
    ];
  }
}
