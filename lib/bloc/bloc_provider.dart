import 'package:flutter/material.dart';

class AppFrameBlocProvider<T> extends InheritedWidget {
  final T bloc;

  AppFrameBlocProvider({@required Widget child, this.bloc})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static of<T>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppFrameBlocProvider<T>>()
        .bloc;
  }
}
