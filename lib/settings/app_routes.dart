import 'package:flutter/material.dart';

import 'package:Food_Bar/custom_bloc/bloc.dart';
import 'package:Food_Bar/screens/screens.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/home': (BuildContext context) {
        return AppFrameBlocProvider<AppFrameBloc>(
            bloc: AppFrameBloc(),
            child: AppFrame(),
        );
      },
      '/category': (BuildContext context) {
        return AppFrameBlocProvider<CategoryBloc>(
          child: SingleCategory(),
          bloc: CategoryBloc(),
        );
      }
    };
  }
}
