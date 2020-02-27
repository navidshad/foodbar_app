import 'package:flutter/material.dart';

import 'package:foodbar_user/bloc/bloc.dart';
import 'package:foodbar_user/screens/screens.dart';
import 'package:foodbar_user/settings/types.dart';
import 'package:foodbar_user/services/options_service.dart';

class MenuTab extends StatefulWidget {
  @override
  _MenuTabState createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  MenuBloc bloc;
  OptionsService options = OptionsService.instance;

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
    MenuEvent event = MenuEvent(options.properties.menuType);
    bloc.eventSink.add(event);
  }
}
