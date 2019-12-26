import 'package:rxdart/rxdart.dart';
import 'dart:async';

abstract class BlocInterface<BlocEvent, BlocState> {
  final StreamController _stateController = BehaviorSubject<BlocState>();
  Stream<BlocState> get stateStream => _stateController.stream;

  final StreamController _eventController = BehaviorSubject<BlocEvent>();
  StreamSink<BlocEvent> get eventSink => _eventController.sink;

  BlocInterface() {
    _eventController.stream.listen(_handler);
  }

  void _handler(BlocEvent event) {}

  BlocState getInitialState() { return null; }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}
