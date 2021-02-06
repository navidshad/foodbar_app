import 'dart:async';
import 'package:foodbar_flutter_core/interfaces/auth_interface.dart';
import 'package:foodbar_admin/services/services.dart';
import 'package:foodbar_admin/settings/settings.dart';
import 'package:rxdart/rxdart.dart';

import 'package:foodbar_flutter_core/interfaces/bloc_interface.dart';
import 'package:foodbar_admin/settings/types.dart';

class AppFrameState {
  FrameTabType type;
  String title;

  AppFrameState(this.title, this.type);
}

class AppFrameEvent {
  //FrameTabType switchFrom;
  FrameTabType switchTo;

  AppFrameEvent({this.switchTo});
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

  final _tabTypeController = BehaviorSubject<FrameTabType>();
  Stream<FrameTabType> get tabTypeStream => _tabTypeController.stream;

  static FrameTabType currentType = FrameTabType.DASHBOARD;
  static String title;

  AppFrameBloc() {
    AppFrameBloc.title = getTitleFromType(FrameTabType.DASHBOARD);
    _eventController.stream.listen(handler);
  }

  String getTitleFromType(FrameTabType type) {
    return options.properties.tabDetails[type].title;
  }

  void handler(AppFrameEvent event) {
  
    FrameTabType type = event.switchTo;
    String title = getTitleFromType(type);

    AppFrameBloc.currentType = type;
    AppFrameBloc.title = title;

    AppFrameState state = AppFrameState(title, type);
    _stateController.add(state);
    _tabTypeController.add(type);
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
    _tabTypeController.close();
  }

  // static FrameTabType switchType(FrameTabType type) {
  //   return (type == FrameTabType.MENU) ? FrameTabType.CART : FrameTabType.MENU;
  // }

  @override
  AppFrameState getInitialState() {
    return AppFrameState(AppFrameBloc.title, AppFrameBloc.currentType);
  }
}
