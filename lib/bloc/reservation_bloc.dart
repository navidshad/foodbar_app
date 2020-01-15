import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:Food_Bar/interfaces/bloc_interface.dart';
import 'package:Food_Bar/interfaces/reservation_schedule_provider.dart';
import 'package:Food_Bar/services/services.dart';
import 'package:Food_Bar/models/models.dart';

class ReservationBloc
    implements BlocInterface<ReservationEvent, ReservationState> {
  //
  // controllers -------------------------------------------
  //
  final StreamController<ReservationState> _stateController = BehaviorSubject();
  final StreamController<PersonPickerOptions> _personController =
      BehaviorSubject();
  final StreamController<List<CustomTable>> _tableController =
      BehaviorSubject();
  final StreamController<ReservationEvent> _eventController = BehaviorSubject();

  ReservationScheduleProvider _service = MockScheduleService();

  ReservationBloc() {
    _eventController.stream.listen(handler);
  }

  //
  // streams -------------------------------------------------
  //
  @override
  StreamSink<ReservationEvent> get eventSink => _eventController.sink;

  @override
  Stream<ReservationState> get stateStream => _stateController.stream;

  Stream<List<CustomTable>> get tableStream => _tableController.stream;
  Stream<PersonPickerOptions> get personStream => _personController.stream;

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
  }

  @override
  void handler(ReservationEvent event) async {
    if (event is GetScheduleOptions) {
      _service.getScheduleOptions().then(((options) {
        _stateController.add(ReservationState(options: options));
      }));
    } else if (event is GetTables) {
      _service.getTableTypes().then((tables) {
        _tableController.add(tables);
      });
    } else if (event is GetTotalPerson) {
      //GetTotalPerson eventDetail = event;
      _service.getTotalPerson(event.date, event.table).then((int totalPerson) {
        _personController.add(PersonPickerOptions(
          divisions: totalPerson,
          min: 0,
          max: totalPerson.toDouble(),
        ));
      });
    }
  }
}

class ReservationEvent {}

class GetScheduleOptions extends ReservationEvent {}

class GetTables extends ReservationEvent {}

class GetTotalPerson extends ReservationEvent {
  DateTime date;
  CustomTable table;

  GetTotalPerson({this.date, this.table});
}

class ReservationState {
  ReservationScheduleOption options;
  ReservationState({this.options});
}
