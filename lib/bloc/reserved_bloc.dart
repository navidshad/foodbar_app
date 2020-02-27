import 'dart:async';
import 'package:foodbar_flutter_core/models/reserved_table.dart';
import 'package:rxdart/rxdart.dart';

import 'package:foodbar_flutter_core/interfaces/bloc_interface.dart';
import 'package:foodbar_user/interfaces/content_provider.dart';
import 'package:foodbar_user/services/services.dart';

class ReservedBloc implements BlocInterface<ReservedEvent, ReservedState> {
  StreamController<ReservedState> _stateController = BehaviorSubject();
  StreamController<ReservedEvent> _eventController = BehaviorSubject();

  ContentProvider _contentService = ContentService.instance;

  ReservedBloc() {
    _eventController.stream.listen(handler);
  }

  @override
  StreamSink<ReservedEvent> get eventSink => _eventController.sink;

  @override
  Stream<ReservedState> get stateStream => _stateController.stream;

  @override
  ReservedState getInitialState() {
    return ReservedState();
  }

  @override
  void handler(ReservedEvent event) async {
    ReservedState state;

    if (event is GetOldReservedTables) {
      await _contentService.getReservedTables().then((reservedList) {
        state = ReservedState(reservedList);
      });

    } else if (event is CancelReservedTable) {
      
    }

    if (state != null) _stateController.add(state);
  }

  @override
  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}

class ReservedEvent {}

class GetOldReservedTables extends ReservedEvent {}

class CancelReservedTable extends ReservedEvent {
  String reservedId;
  CancelReservedTable(this.reservedId);
}

class ReservedState {
  List<ReservedTable> reservedList;
  ReservedState([this.reservedList = const []]);
}
