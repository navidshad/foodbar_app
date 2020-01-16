import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:Food_Bar/interfaces/bloc_interface.dart';
import 'package:Food_Bar/interfaces/reservation_schedule_provider.dart';
import 'package:Food_Bar/services/services.dart';
import 'package:Food_Bar/models/models.dart';

class ReservationBloc
    implements BlocInterface<ReservationEvent, ReservationState> {
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

  ReservationScheduleProvider _service = MockScheduleService();

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
  // initializers ---------------------------------------------
  //
  @override
  ReservationState getInitialState() {
    return ReservationState();
  }

  PersonPickerOptions getPersonPickerIntialState() {
    return PersonPickerOptions(
      divisions: 0,
      max: 0,
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
      _service.getScheduleOptions().then(((options) {
        _stateController.add(ReservationState(options: options));
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
      _service.getTotalPerson(event.date, event.table).then((int totalPerson) {
        _personController.add(PersonPickerOptions(
          divisions: totalPerson,
          min: 0,
          max: totalPerson.toDouble(),
        ));
      });

      //
      // get and stream reserved time per day
    } else if (event is GetReservedTimes) {
      _service.getReservedDailyTime(event.date).then((times) {
        _reservedTimeController.add(times);
      });
    }
  }
}

class ReservationEvent {}

class GetScheduleOptions extends ReservationEvent {}

class GetTables extends ReservationEvent {}

class GetReservedTimes extends ReservationEvent {
  DateTime date;
  GetReservedTimes(this.date);
}

class GetTotalPerson extends ReservationEvent {
  DateTime date;
  CustomTable table;
  GetTotalPerson({this.date, this.table});
}

class ReservationState {
  ReservationScheduleOption options;
  ReservationState({this.options});
}
