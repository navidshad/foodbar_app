
import 'package:Food_Bar/models/models.dart';

abstract class ReservationScheduleProvider {

  Future<List<Table>> getReseredTables(DateTime date);

  Future<ReservationScheduleOption> getSchedule();

}