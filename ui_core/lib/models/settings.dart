import 'package:foodbar_flutter_core/foodbar_flutter_core.dart';

import 'package:foodbar_flutter_core/mongodb/field.dart';
import 'package:foodbar_flutter_core/settings/types.dart';

class Settings  {
  String title;
  String slagon;

  MenuType menuType;

  int deliveryCharges;
  int totalAllowedDaysForReservation;
  int timeDividedPerMitutes;
  int timeToDeliveryFromNowByMinutes;
  int timeToDeliveryBeforClosedResturantByMinutes;

  ImageDetail vertivalImage;
  ImageDetail horizontalImage;

  static List<DbField> getDbFields() {
    return [
      DbField('title'),
      DbField('slagon'),
      DbField('menuType', fieldType: FieldType.select, subFields: [
        DbField('onePage', customTitle: 'One Page', strvalue: 'onePage'),
        DbField('twoPage', customTitle: 'Two Page', strvalue: 'twoPage'),
      ]),
      DbField('deliveryCharges',
          dataType: DataType.int, fieldType: FieldType.number),
      DbField('totalAllowedDaysForReservation',
          dataType: DataType.int, fieldType: FieldType.number),
      DbField('timeDividedPerMitutes',
          dataType: DataType.int, fieldType: FieldType.number),
      DbField('timeToDeliveryFromNowByMinutes',
          dataType: DataType.int, fieldType: FieldType.number),
      DbField('timeToDeliveryBeforClosedResturantByMinutes',
          dataType: DataType.int, fieldType: FieldType.number),
      DbField('vertivalImage',
          dataType: DataType.object, fieldType: FieldType.image),
      DbField('horizontalImage',
          dataType: DataType.object, fieldType: FieldType.image),
    ];
  }
}
