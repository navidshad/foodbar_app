import 'dart:math';

import 'package:foodbar_user/interfaces/reservation_schedule_provider.dart';
import 'package:foodbar_user/models/models.dart';
import 'package:foodbar_user/models/reservation_schedule_option.dart';
import 'package:foodbar_user/models/table.dart';

class MockScheduleService implements ReservationProviderInterface {
  @override
  Future<List<DateTime>> getReservedTimes(DateTime day, String tableId) {
    return Future.delayed(Duration(seconds: 1)).then((r) {
      return [
        DateTime(day.year, day.month, day.day, 14, 00),
        DateTime(day.year, day.month, day.day, 18, 00),
        DateTime(day.year, day.month, day.day, 20, 00),
      ];
    });
  }

  @override
  Future<ReservationScheduleOption> getScheduleOptions() {
    return Future.delayed(Duration(seconds: 1))
        .then((r) => ReservationScheduleOption(
              from: DateTime.now(),
              totalDays: 7,
              periods: [Period(from: Time(houre: 12), to: Time(houre: 21))],
            ));
  }

  @override
  Future<List<CustomTable>> getTableTypes() {
    return Future.delayed(Duration(seconds: 1)).then((r) {
      return [
        BoardTable(count: 2, persons: 4, title: 'Board Table 4p'),
        BoardTable(count: 2, persons: 6, title: 'Board Table 6p'),
        RollBandTable(persons: 20, title: 'Roll Band')
      ];
    });
  }

  @override
  Future<int> getRemainPersons(DateTime date, CustomTable table) {
    return Future.delayed(Duration(seconds: 1)).then((r) {
      if (table is RollBandTable)
        return table.persons;
      else if (table is BoardTable)
        return table.persons;
      else
        return 0;
    });
  }

  @override
  Future<ReserveConfirmationResult> reserve(
      {int persons, CustomTable table, DateTime date}) {
    return Future.delayed(Duration(seconds: 1)).then((r) {
      Random random = Random(-5);
      int number = random.nextInt(5);

      if (number <= 0)
        throw ReserveConfirmationResult(
            message: 'Your order has not been confirmed, try agaim, please',
            succeed: false);
      else
        return ReserveConfirmationResult(
            message: 'Your request is confirmed, this is your reservation ID:',
            succeed: true,
            reservationId: 344234234);
    });
  }
}
