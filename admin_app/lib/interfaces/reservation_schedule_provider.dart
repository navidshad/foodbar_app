import 'package:foodbar_flutter_core/models/models.dart';

abstract class ReservationProviderInterface {
  Future<List<CustomTable>> getTableTypes();

  Future<ReservationScheduleOption> getScheduleOptions();

  Future<List<DateTime>> getReservedTimes(DateTime day, String tableId);

  Future<int> getRemainPersons(DateTime date, CustomTable table);

  Future<ReserveConfirmationResult> reserve(
      {required int persons,
      required CustomTable table,
      required DateTime date});
}
