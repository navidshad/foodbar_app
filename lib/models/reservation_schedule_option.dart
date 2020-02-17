import 'package:Food_Bar/models/permission.dart';
import 'package:meta/meta.dart';

import 'time.dart';

class ReservationScheduleOption {
  int totalDays;
  DateTime from;
  List<Period> periods;

  ReservationScheduleOption({
    @required this.from,
    @required this.totalDays,
    @required this.periods,
  });

  factory ReservationScheduleOption.fromMap(Map detail) {
    List<Period> periods = [];

    if (detail.containsKey('periods')) {
      List pList = detail['periods'];
      pList.forEach((p) {
        periods.add(Period.fromMap(p));
      });
    }

    ReservationScheduleOption options = ReservationScheduleOption(
      from: DateTime.parse(detail['from']),
      totalDays: detail['totalDays'],
      periods: periods,
    );

    return options;
  }
}
