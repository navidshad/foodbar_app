import 'package:rxdart/rxdart.dart';
import 'dart:async';

abstract class BlocInterface<BlocEvent, BlocState> {
  final StreamController<BlocState> _stateController = BehaviorSubject();
  Stream<BlocState> get stateStream => _stateController.stream;

  final StreamController<BlocEvent> _eventController = BehaviorSubject();
  StreamSink<BlocEvent> get eventSink => _eventController.sink;

  BlocInterface() {
    _eventController.stream.listen(handler);
  }

  void handler(BlocEvent event);

  BlocState getInitialState();

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}
