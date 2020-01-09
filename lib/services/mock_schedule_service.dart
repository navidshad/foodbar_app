import 'dart:math';

import 'package:Food_Bar/interfaces/reservation_schedule_provider.dart';
import 'package:Food_Bar/models/reservation_schedule_option.dart';
import 'package:Food_Bar/models/table.dart';

class MockScheduleService implements ReservationScheduleProvider {
  @override
  Future<List<Table>> getReseredTables(DateTime date) {
    return Future.delayed(Duration(milliseconds: 1000))
      .whenComplete(() {

        int totalTables = 15;
        int reserved = Random(0).nextInt(totalTables);
        List<Table> tables = [];

        for(int i=0; i < reserved; i++) {
          
        }

      });
  }

  @override
  Future<ReservationScheduleOption> getSchedule() {
    return Future.delayed(Duration(microseconds: 200)).whenComplete(() {
      return ReservationScheduleOption(from: DateTime.now(), totalDays: 7);
    });
  }
}
