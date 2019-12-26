import 'package:Food_Bar/settings/types.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/screens/screens.dart';
import 'package:Food_Bar/settings/app_properties.dart';
import 'package:Food_Bar/settings/types.dart';

class MenuTab extends StatefulWidget {
  @override
  _MenuTabState createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  MenuBloc bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<MenuBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.stateStream,
      initialData: bloc.getInitialState(),
      builder: (streamContext, AsyncSnapshot snapshop) {
        MenuState state = snapshop.data;
        Widget widget;

        if (state.isInitState) {
          loadMenu();
          widget = Center(child: CircularProgressIndicator());
        } else if (state.type == MenuType.OnePage) {
          widget = MenuTabOnePageView(state.categoriesWithFoods);
        } else if (state.type == MenuType.TwoPage) {
          widget = MenuTabTwoPageCategoriesView(state.categories);
        }

        return widget;
      },
    );
  }

  void loadMenu() {
    MenuEvent event = MenuEvent(AppProperties.menuType);
    bloc.eventSink.add(event);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
