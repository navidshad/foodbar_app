import 'package:meta/meta.dart';

import 'package:Food_Bar/settings/settings.dart';

@immutable
abstract class AppFrameState {
  final FrameTabType tabType;
  final String title;

  AppFrameState({this.tabType, this.title});
}

class InitialAppFrameState extends AppFrameState {
  InitialAppFrameState()
      : super(title: AppProperties.menuTitle, tabType: FrameTabType.MENU);
}

class ShowingTabAppFrameState extends AppFrameState {
  ShowingTabAppFrameState({FrameTabType tabType, String title})
      : super(tabType: tabType, title: title);
}

class ChangingAppBarAppFrameState extends AppFrameState {
  ChangingAppBarAppFrameState({FrameTabType tabType, String title})
      : super(tabType: tabType, title: title);
}
