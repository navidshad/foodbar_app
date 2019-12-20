import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/screens/screens.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    List<BlocProvider> blocProviders = [
      BlocProvider<AppFrameBloc>(
        create: (BuildContext con) => AppFrameBloc(),
      ),
      BlocProvider<MenuBloc>(
        create: (BuildContext con) => MenuBloc(),
      ),
      BlocProvider<CartBloc>(
        create: (BuildContext con) => CartBloc(),
      ),
    ];

    return {
      '/home': (BuildContext context) {
        return MultiBlocProvider(
          child: AppFrame(),
          providers: blocProviders,
        );
      },
      '/category': (BuildContext context) {
        return MultiBlocProvider(
          child: SingleCategory(),
          providers: blocProviders,
        );
      }
    };
  }
}
