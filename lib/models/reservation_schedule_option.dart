import 'package:meta/meta.dart';

import 'time.dart';

class ReservationScheduleOption {
  int totalDays;
  DateTime from;
  List<Period> periods;
  //List<DateTime> reservedTimes = [];

  ReservationScheduleOption({
    @required this.from,
    @required this.totalDays,
    @required this.periods,
  });
}
