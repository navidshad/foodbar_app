import 'dart:async';
import 'package:foodbar_flutter_core/interfaces/auth_interface.dart';
import 'package:rxdart/rxdart.dart';

import 'package:foodbar_flutter_core/interfaces/bloc_interface.dart';
import 'package:foodbar_user/interfaces/reservation_schedule_provider.dart';
import 'package:foodbar_user/services/services.dart';
import 'package:foodbar_flutter_core/models/models.dart';

class ReservationBloc
    implements BlocInterface<ReservationEvent, ReservationState> {
  final AuthInterface authService = AuthService.instant;

  //
  // constructor ---------------------------------------------
  //
  ReservationBloc() {
    _eventController.stream.listen(handler);
  }

  //
  // controllers -------------------------------------------
  //
  final StreamController<ReservationState> _stateController = BehaviorSubject();

  final StreamController<ReservationEvent> _eventController = BehaviorSubject();

  final StreamController<List<DateTime>> _reservedTimeController =
      BehaviorSubject();

  final StreamController<PersonPickerOptions> _personController =
      BehaviorSubject();

  final StreamController<List<CustomTable>> _tableController =
      BehaviorSubject();

  ReservationProviderInterface _service = ReservationService.instance;

  //
  // streams -------------------------------------------------
  //
  @override
  StreamSink<ReservationEvent> get eventSink => _eventController.sink;

  @override
  Stream<ReservationState> get stateStream => _stateController.stream;

  Stream<List<CustomTable>> get tableStream => _tableController.stream;
  Stream<PersonPickerOptions> get personStream => _personController.stream;

  Stream<List<DateTime>> get reservedTimeStream =>
      _reservedTimeController.stream;

  //
  // values ---------------------------------------------------
  //
  static CustomTable selectedTable;
  static DateTime selectedDate;
  static DateTime selectedTime;
  static int selectedPersons = 0;

  //
  // initializers ---------------------------------------------
  //
  @override
  ReservationState getInitialState() {
    return ScheduleState();
  }

  PersonPickerOptions getPersonPickerIntialState() {
    return PersonPickerOptions(
      divisions: 1,
      max: 1,
      min: 0,
    );
  }

  //
  // others methods ------------------------------------------
  //
  @override
  void dispose() {
    _stateController.close();
    _eventController.close();
    _personController.close();
    _reservedTimeController.close();
  }

  @override
  void handler(ReservationEvent event) {
    //
    // get and stream Schedule options
    if (event is GetScheduleOptions) {
      _service.getScheduleOptions().then(((options) async {
        selectedDate = options.from;
        _stateController.add(ScheduleState(options: options));
      }));

      //
      // get and stream types of table
    } else if (event is GetTables) {
      _service.getTableTypes().then((tables) {
        _tableController.add(tables);
      });

      //
      // get and stream allowed total person to reserve
    } else if (event is GetTotalPerson) {
      //GetTotalPerson eventDetail = event;
      _service
          .getRemainPersons(selectedTime, selectedTable)
          .then((int totalPerson) {
        PersonPickerOptions options = PersonPickerOptions(
          divisions: totalPerson,
          min: 0,
          max: totalPerson.toDouble(),
        );

        _personController.add(options);
      });

      //
      // get and stream reserved time per day
    } else if (event is GetReservedTimes) {
      _reservedTimeController.add(null);

      _service.getReservedTimes(selectedDate, selectedTable.id).then((times) {
        _reservedTimeController.add(times);
      });

      //
      // request to reserve a table and
      // stream its result state
    } else if (event is ReserveTable) {
      ConfirmState state = ConfirmState(waitingForResult: true);
      _stateController.add(state);

      _service
          .reserve(
              date: selectedTime,
              persons: selectedPersons,
              table: selectedTable)
          // return success state
          .then((result) {
        state = ConfirmState(result: result);
        _stateController.add(state);
      })
          // return error state
          .catchError((dynamic result) {
        state = ConfirmState(result: result);
        _stateController.add(state);
      });
    }
  }
}

class ReservationEvent {}

class GetScheduleOptions extends ReservationEvent {}

class GetTables extends ReservationEvent {}

class GetReservedTimes extends ReservationEvent {
  // DateTime date;
  // String tableId;
  // GetReservedTimes(this.date, this.tableId);
}

class GetTotalPerson extends ReservationEvent {
  // DateTime date;
  // CustomTable table;
  // GetTotalPerson({this.date, this.table});
}

class ReserveTable extends ReservationEvent {
  // int persons;
  // CustomTable table;
  // DateTime date;

  // ReserveTable({this.persons, this.date, this.table});
}

class ReservationState {}

class ScheduleState extends ReservationState {
  ReservationScheduleOption options;
  ScheduleState({this.options});
}

class ConfirmState extends ReservationState {
  bool waitingForResult;
  ReserveConfirmationResult result;

  ConfirmState({this.waitingForResult = false, this.result});
}
