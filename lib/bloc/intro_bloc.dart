import 'dart:async';

import 'package:Food_Bar/interfaces/bloc_interface.dart';
import 'package:rxdart/rxdart.dart';
import 'package:Food_Bar/settings/types.dart';

class IntroBloc implements BlocInterface<IntroEvent, IntroState> {
  final StreamController<IntroEvent> _eventController = BehaviorSubject();
  StreamSink<IntroEvent> get eventSink => _eventController.sink;

  final StreamController<IntroState> _stateController = BehaviorSubject();
  Stream<IntroState> get stateStream => _stateController.stream;

  IntroBloc() {
    _eventController.stream.listen(handler);
  }

  @override
  void dispose() {
    _eventController.close();
    _stateController.close();
  }

  @override
  IntroState getInitialState() {
    return IntroState(type: IntroTabType.Splash);
  }

  @override
  void handler(IntroEvent event) async {
    IntroState state = IntroState(type: event.switchTo);
    _stateController.add(state);
  }
}

class IntroEvent {
  IntroTabType switchTo;

  IntroEvent({this.switchTo});
}

class IntroState {
  IntroTabType type;

  IntroState({this.type});
}

