import 'package:foodbar_flutter_core/foodbar_flutter_core.dart';

import 'package:foodbar_flutter_core/mongodb/field.dart';
import 'package:foodbar_flutter_core/settings/types.dart';

class Settings {
  String title = 'Title';
  String slagon = 'Slagon';

  MenuType menuType = MenuType.OnePage;

  int deliveryCharges = 0;
  int totalAllowedDaysForReservation = 3;
  int timeDividedPerMitutes = 30;
  int timeToDeliveryFromNowByMinutes = 30;
  int timeToDeliveryBeforClosedResturantByMinutes = 40;

  ImageDetail? vertivalImage;
  ImageDetail? horizontalImage;

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
