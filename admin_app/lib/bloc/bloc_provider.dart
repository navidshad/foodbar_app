import 'package:flutter/material.dart';

class BlocProvider<T> extends InheritedWidget {
  final T bloc;

  BlocProvider({required Widget child, required this.bloc})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static of<T>(BuildContext context) {
    T bloc =
        context.dependOnInheritedWidgetOfExactType<BlocProvider<T>>()!.bloc;
    return bloc;
  }
}
