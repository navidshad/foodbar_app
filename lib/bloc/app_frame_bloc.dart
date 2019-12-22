import 'dart:async';
import 'package:Food_Bar/settings/settings.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class AppFrameBloc extends Bloc<AppFrameEvent, AppFrameState> {
  @override
  AppFrameState get initialState => InitialAppFrameState();

  @override
  Stream<AppFrameState> mapEventToState(
    AppFrameEvent event,
  ) async* {
    String title = getTitleFromType(event.changeTo);

    // if (event is ChangeTabAppFrameEvent) {
    //   yield ShowingTabAppFrameState(title: title, tabType: event.changeTo);
    // }
    //  else if(event is ChangeAppBarAppFrameEvent) {
    //   yield ChangingAppBarAppFrameState(title: title, tabType: event.changeTo);
    // }

    yield ShowingTabAppFrameState(title: title, tabType: event.changeTo);
    yield ChangingAppBarAppFrameState(title: title, tabType: event.changeTo);
  }

  String getTitleFromType(FrameTabType type)
  {
    if (type == FrameTabType.CART)
      return AppProperties.cartTitle;
    else
      return AppProperties.menuTitle;
  }

  static FrameTabType switchType(FrameTabType type) {
    return (type == FrameTabType.MENU) ? FrameTabType.CART : FrameTabType.MENU;
  }

  static bool blocCondition(AppFrameState state, List<Type> types) {
    return (types.indexOf(state.runtimeType) > -1);
  }
}
