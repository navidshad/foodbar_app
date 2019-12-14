import 'package:meta/meta.dart';

import 'package:Food_Bar/settings/types.dart';

@immutable
abstract class AppFrameEvent {
  final FrameTabType changeTo;
  AppFrameEvent(this.changeTo);
}

class ChangeAppBarAppFrameEvent extends AppFrameEvent {
  ChangeAppBarAppFrameEvent(FrameTabType changeTo)
    : super(changeTo);
}

class ChangeTabAppFrameEvent extends AppFrameEvent {
  ChangeTabAppFrameEvent(FrameTabType changeTo)
    : super(changeTo);
}

