import 'dart:async';
import 'package:Food_Bar/settings/settings.dart';
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
  FrameTabType switchTo;

  AppFrameEvent({this.switchFrom, this.switchTo});
}

class AppFrameBloc implements BlocInterface<AppFrameEvent, AppFrameState> {
  // state stream
  final _stateController = BehaviorSubject<AppFrameState>();
  Stream<AppFrameState> get stateStream => _stateController.stream;

  // event stream
  final _eventController = BehaviorSubject<AppFrameEvent>();
  StreamSink<AppFrameEvent> get eventSink => _eventController.sink;

  static FrameTabType currentType = FrameTabType.MENU;
  static String title = AppProperties.menuTitle;

  AppFrameBloc() {
    _eventController.stream.listen(handler);
  }

  void handler(AppFrameEvent event) {
    String title;
    FrameTabType type;

    // define frame type
    if (event.switchFrom != null) {
      type = _switchFrom(event.switchFrom);
    } else if (event.switchTo != null) {
      type = event.switchTo;
    }

    // define title
    switch(type) {
      case FrameTabType.CART: title = AppProperties.cartTitle; break;
      case FrameTabType.MENU: title = AppProperties.menuTitle; break;
      case FrameTabType.Reserve: title = AppProperties.reservationTitle; break;
    }

    AppFrameBloc.currentType = type;
    AppFrameBloc.title = title;

    AppFrameState state = AppFrameState(title, type);
    _stateController.add(state);
  }

  FrameTabType _switchFrom(FrameTabType type) {
    FrameTabType temp;

    if (type == FrameTabType.CART) {
      temp = FrameTabType.MENU;
    } else {
      temp = FrameTabType.CART;
    }

    return temp;
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
    return AppFrameState(AppFrameBloc.title, AppFrameBloc.currentType);
  }
}
