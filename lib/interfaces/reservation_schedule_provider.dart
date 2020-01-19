
import 'package:Food_Bar/models/models.dart';

abstract class ReservationScheduleProvider {

  Future<List<CustomTable>> getTableTypes();

  Future<ReservationScheduleOption> getScheduleOptions();

  Future<List<DateTime>> getReservedDailyTime(DateTime day);

  Future<int> getTotalPerson(DateTime date, CustomTable table);
  
  Future<String> reserve({int persons, CustomTable table, DateTime date});
}