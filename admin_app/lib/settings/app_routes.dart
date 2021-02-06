import 'package:foodbar_admin/bloc/intro_bloc.dart';
import 'package:flutter/material.dart';

import 'package:foodbar_admin/bloc/bloc.dart';
import 'package:foodbar_admin/screens/screens.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {

      '/intro': (BuildContext context) {
        return BlocProvider<IntroBloc>(
          bloc: IntroBloc(),
          child: Intro(),
        );
      },
      
      '/home': (BuildContext context) {
        return BlocProvider<AppFrameBloc>(
          bloc: AppFrameBloc(),
          child: AppFrame(),
        );
      },

    };
  }
}
