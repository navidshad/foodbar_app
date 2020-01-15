import 'dart:math';

import 'package:Food_Bar/interfaces/reservation_schedule_provider.dart';
import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/models/reservation_schedule_option.dart';
import 'package:Food_Bar/models/table.dart';

class MockScheduleService implements ReservationScheduleProvider {
  @override
  Future<List<DateTime>> getReservedDailyTime(DateTime day) {
    //return Future<>
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
  Future<int> getTotalPerson(DateTime date, CustomTable table) {
    return Future.delayed(Duration(seconds: 1)).then((r) {
      if (table is RollBandTable)
        return table.persons;
      else if (table is BoardTable)
        return table.persons;
      else
        return 0;
    });
  }
}
