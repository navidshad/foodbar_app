import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:Food_Bar/interfaces/bloc_interface.dart';
import 'package:Food_Bar/settings/types.dart';

class AppFrameState {
  FrameTabType type;
  String title;

  AppFrameState(this.title, this.type);
}

class AppFrameEvent {
  FrameTabType switchFrom;

  AppFrameEvent(this.switchFrom);
}

class AppFrameBloc implements BlocInterface<AppFrameEvent, AppFrameState> {
  // state stream
  final _stateController = BehaviorSubject<AppFrameState>();
  Stream<AppFrameState> get stateStream => _stateController.stream;

  // event stream
  final _eventController = BehaviorSubject<AppFrameEvent>();
  StreamSink<AppFrameEvent> get eventSink => _eventController.sink;

  static FrameTabType currentType = FrameTabType.MENU;

  AppFrameBloc() {
    _eventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(AppFrameEvent event) {
    String title;
    FrameTabType type;

    if (event.switchFrom == FrameTabType.CART) {
      title = 'Menu';
      type = FrameTabType.MENU;
    } else{
      title = 'My Cart';
      type = FrameTabType.CART;
    }

    AppFrameBloc.currentType = type;

    AppFrameState state = AppFrameState(title, type);
    _stateController.add(state);
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }

  static FrameTabType switchType(FrameTabType type) {
    return (type == FrameTabType.MENU) ? FrameTabType.CART : FrameTabType.MENU;
  }

  @override
  AppFrameState getInitialState() {
    return AppFrameState('Menu', AppFrameBloc.currentType);
  }
}
