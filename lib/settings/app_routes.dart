import 'package:flutter/material.dart';

import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/screens/screens.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
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
