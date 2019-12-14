import 'package:Food_Bar/settings/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/screens/screens.dart';
import 'package:Food_Bar/settings/app_properties.dart';

class MenuTab extends StatefulWidget {
  @override
  _MenuTabState createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  MenuBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<MenuBloc>(context);

    return BlocBuilder(
      bloc: bloc,
      builder: (blocContext, MenuState state) {
        if (state is InitialMenuState) {
          loadMenu();
          return CircularProgressIndicator();
        } else if (state is ShowOnePageMenuMenuState) {
          ShowOnePageMenuMenuState stateDetail = state;
          return MenuTabOnePageView(stateDetail.list);
        } else {
          ShowCategoriesMenuState stateDetail = state;
          return null;
        }
      },
    );
  }

  void loadMenu() {
    MenuEvent event;

    switch (AppProperties.menuType) {
      case MenuType.OnePage:
        event = GetOnePageMenuMenuEvent();
        break;

      case MenuType.TwoPage:
        event = GetCategoriesMenuEvent();
        break;
    }

    bloc.add(event);
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}
