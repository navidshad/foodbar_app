import 'package:meta/meta.dart';

class ReservationScheduleOption {
  int totalDays;
  DateTime from;

  ReservationScheduleOption({@required this.from, @required this.totalDays});
}