import 'package:foodbar_admin/bloc/intro_bloc.dart';
import 'package:flutter/material.dart';

import 'package:foodbar_admin/bloc/bloc.dart';
import 'package:foodbar_admin/screens/intro/login.dart';
import 'package:foodbar_admin/screens/intro/register.dart';
import 'package:foodbar_admin/screens/intro/splash.dart';
import 'package:foodbar_admin/screens/screens.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/splash': (context) => SplashScreen(),
      '/login': (context) => LoginScreen(),
      '/register': (context) => RegisterScreen(),
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
