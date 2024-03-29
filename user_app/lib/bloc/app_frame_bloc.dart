import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:foodbar_flutter_core/interfaces/auth_interface.dart';
import 'package:foodbar_user/services/services.dart';
import 'package:foodbar_user/settings/settings.dart';
import 'package:rxdart/rxdart.dart';

import 'package:foodbar_flutter_core/interfaces/bloc_interface.dart';
import 'package:foodbar_flutter_core/settings/types.dart';

class AppFrameState {
  FrameTabType type;
  String title;

  AppFrameState(this.title, this.type);
}

class AppFrameEvent {
  FrameTabType switchFrom;
  FrameTabType switchTo;

  AppFrameEvent({required this.switchFrom, required this.switchTo});
}

class ColorSwiche {
  Color color;
  Color onColor;

  ColorSwiche({required this.color, required this.onColor});
}

class AppFrameBloc implements BlocInterface<AppFrameEvent, AppFrameState> {
  AuthInterface authService = AuthService.instant;
  OptionsService options = OptionsService.instance;

  // state stream
  final _stateController = BehaviorSubject<AppFrameState>();
  Stream<AppFrameState> get stateStream => _stateController.stream;

  // event stream
  final _eventController = BehaviorSubject<AppFrameEvent>();
  StreamSink<AppFrameEvent> get eventSink => _eventController.sink;

  // background color stream
  final _colorController = BehaviorSubject<ColorSwiche>();
  Stream<ColorSwiche> get colorStream => _colorController.stream;
  StreamSink get colorSink => _colorController.sink;

  static FrameTabType currentType = FrameTabType.MENU;
  static String title = '';

  AppFrameBloc() {
    AppFrameBloc.title = options.properties.menuTitle;
    _eventController.stream.listen(handler);
  }

  void handler(AppFrameEvent event) {
    String title;
    late FrameTabType type;

    // define frame type
    if (event.switchFrom != null) {
      type = _switchFrom(event.switchFrom);
    } else if (event.switchTo != null) {
      type = event.switchTo;
    }

    // define title
    switch (type) {
      case FrameTabType.CART:
        title = options.properties.cartTitle;
        break;
      case FrameTabType.MENU:
        title = options.properties.menuTitle;
        break;
      case FrameTabType.RESERVATION:
        title = options.properties.reservationTitle;
        break;
      case FrameTabType.ORDERS:
        title = options.properties.myOrdersTitle;
        break;
      case FrameTabType.RESERVED:
        title = options.properties.oldReservedTitle;
        break;
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
