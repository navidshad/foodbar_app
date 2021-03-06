import 'package:foodbar_user/bloc/intro_bloc.dart';
import 'package:flutter/material.dart';

import 'package:foodbar_user/bloc/bloc.dart';
import 'package:foodbar_user/screens/screens.dart';

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
          child: BlocProvider<CartBloc>(
            bloc: CartBloc(),
            child: BlocProvider<ReservationBloc>(
              bloc: ReservationBloc(),
              child: AppFrame(),
            ),
          ),
        );
      },
      '/category': (BuildContext context) {
        return BlocProvider<AppFrameBloc>(
          bloc: AppFrameBloc(),
          child: BlocProvider<CartBloc>(
            bloc: CartBloc(),
            child: BlocProvider<CategoryBloc>(
              child: SingleCategory(),
              bloc: CategoryBloc(),
            ),
          ),
        );
      },
      '/food': (BuildContext context) {
        return BlocProvider<AppFrameBloc>(
          bloc: AppFrameBloc(),
          child: BlocProvider<CartBloc>(
            child: SingleFood(),
            bloc: CartBloc(),
          ),
        );
      }
    };
  }
}
