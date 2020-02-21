import 'package:http/http.dart';
import 'dart:convert';

import 'package:Food_Bar/interfaces/reservation_schedule_provider.dart';
import 'package:Food_Bar/models/reservation_schedule_option.dart';
import 'package:Food_Bar/models/reserve_confirmation_result.dart';
import 'package:Food_Bar/models/table.dart';

import 'package:Food_Bar/interfaces/auth_interface.dart';
import 'package:Food_Bar/services/services.dart';
import 'package:Food_Bar/settings/static_vars.dart';

class ReservationService implements ReservationProviderInterface {
  ReservationService.privateContructor();
  static ReservationService instance = ReservationService.privateContructor();

  AuthInterface _authService = AuthService.instant;
  Client _http = Client();

  Map<String, String> get headers {
    return {
      'Content-Type': 'application/json',
      'authorization': _authService.token
    };
  }

  @override
  Future<List<DateTime>> getReservedTimes(DateTime day) async {
    String url = Vars.host + '/reservation/getReservedTimes';

    Map body = {
      'isoDate': day.toUtc().toIso8601String(),
    };

    List<DateTime> times = [];

    await _http
        .post(url, headers: headers, body: json.encode(body))
        .then(_analizeResult)
        .then((result) {
      List list = result['times'];
      //print('getReservedTimes $list');
      list.forEach((reserved) {
        Map reservedDetail = reserved;
        DateTime tempTime = DateTime.parse(reservedDetail['from']);
        times.add(tempTime);
      });
    }).catchError((onError) {
      print('getReservedTimes ${onError.toString()}');
    });

    return times;
  }

  @override
  Future<ReservationScheduleOption> getScheduleOptions() async {
    String url = Vars.host + '/reservation/getScheduleOptions';

    return _http.get(url, headers: headers).then(_analizeResult).then((result) {
      Map optionDetail = result['options'];

      ReservationScheduleOption options =
          ReservationScheduleOption.fromMap(optionDetail);

      return options;
    });
  }

  @override
  Future<List<CustomTable>> getTableTypes() async {
    String url = Vars.host + '/reservation/getTables';

    List<CustomTable> tables = [];

    await _http.get(url, headers: headers).then(_analizeResult).then((result) {
      List tableDocs = result['tables'];

      tableDocs.forEach((t) {
        try {
          tables.add(CustomTable.fromMap(t));
        } catch (e) {}
      });
    }).catchError((onError) {
      print(onError.toString());
    });

    return tables;
  }

  @override
  Future<int> getRemainPersons(DateTime date, CustomTable table) async {
    String url = Vars.host + '/reservation/getRemainPersons';

    Map body = {
      'isoDate': date.toUtc().toIso8601String(),
      'tableId': table.id,
    };

    int remain = 0;

    await _http
        .post(url, headers: headers, body: json.encode(body))
        .then(_analizeResult)
        .then((result) {
      remain = result['remain'];
    }).catchError((onError) {
      print(onError.toString());
    });

    return remain;
  }

  @override
  Future<ReserveConfirmationResult> reserve(
      {int persons, CustomTable table, DateTime date}) async {
    String url = Vars.host + '/reservation/reserveTable';

    Map body = {
      'isoDate': date.toUtc().toIso8601String(),
      'tableId': table.id,
      'persons': persons,
    };

    return _http
        .post(url, headers: headers, body: json.encode(body))
        .then(_analizeResult)
        .then((result) {
      return ReserveConfirmationResult(
        succeed: true,
        reservationId: result['reservedId'],
      );
    }).catchError((onError) {
      return ReserveConfirmationResult(
        succeed: false,
        message: onError.toString(),
      );
    });
  }

  dynamic _analizeResult(Response r) {
    dynamic body;

    try {
      body = jsonDecode(r.body);
    } catch (e) {
      throw e;
    }

    if (r.statusCode != 200) {
      String error = body['error'] ?? body.toString();
      throw error;
    }

    return body;
  }
}
