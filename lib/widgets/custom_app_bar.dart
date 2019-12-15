import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/settings/settings.dart';
import 'package:Food_Bar/utilities/food_bar_icons.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(55);
}

class _CustomAppBarState extends State<CustomAppBar> {
  FrameTabType currentTab;
  AppFrameBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<AppFrameBloc>(context);

    return BlocBuilder(
      bloc: bloc,
      builder: (stateContext, AppFrameState state) {
        return buildAppBar(state.title, state.tabType);
      },
    );
  }

  AppBar buildAppBar(String title, FrameTabType type) {
    Widget actionBtn;
    currentTab = type;

    // setup title and action button according to tabType
    if (type == FrameTabType.MENU) {
      actionBtn = FlatButton(
        child: Icon(FoodBarIcons.shopping_bag),
        onPressed: onAppBarActionButtonPressed,
      );
    } else if (type == FrameTabType.CART) {
      actionBtn = FlatButton(
        child: Icon(FoodBarIcons.spoon_and_fork),
        onPressed: onAppBarActionButtonPressed,
      );
    }

    // build appbar
    return AppBar(
      title: Text(title),
      actions: <Widget>[actionBtn],
    );
  }

  void onAppBarActionButtonPressed() {
    FrameTabType type = AppFrameBloc.switchType(currentTab);
    bloc.add(ChangeTabAppFrameEvent(type));
  }
}
