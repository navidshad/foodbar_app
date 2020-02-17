
import 'package:Food_Bar/models/models.dart';

abstract class ReservationProviderInterface {

  Future<List<CustomTable>> getTableTypes();

  Future<ReservationScheduleOption> getScheduleOptions();

  Future<List<DateTime>> getReservedTimes(DateTime day);

  Future<int> getRemainPersons(DateTime date, CustomTable table);
  
  Future<ReserveConfirmationResult> reserve({int persons, CustomTable table, DateTime date});
}