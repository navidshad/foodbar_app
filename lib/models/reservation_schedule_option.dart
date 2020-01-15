import 'package:meta/meta.dart';

import 'time.dart';

class ReservationScheduleOption {
  int totalDays;
  DateTime from;
  List<Period> periods;

  ReservationScheduleOption({@required this.from, @required this.totalDays, @required this.periods});
}