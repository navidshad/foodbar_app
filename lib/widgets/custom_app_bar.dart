import 'package:Food_Bar/widgets/cart_button.dart';
import 'package:flutter/material.dart';

import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/settings/settings.dart';
import 'package:Food_Bar/utilities/food_bar_icons.dart';
import 'package:Food_Bar/widgets/widgets.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<AppFrameBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.stateStream,
      initialData: bloc.getInitialState(),
      builder: (stateContext, AsyncSnapshot<AppFrameState> snapshot) {
        return buildAppBar(snapshot.data.title, AppFrameBloc.currentType);
      },
    );
  }

  AppBar buildAppBar(String title, FrameTabType type) {
    Widget actionBtn;
    currentTab = type;

    if (type == FrameTabType.MENU) {
      actionBtn = CartButton(
        onTap: onAppBarActionButtonPressed,
      );
    } else {
      actionBtn = FlatButton(
        child: Icon(FoodBarIcons.spoon_and_fork),
        onPressed: onAppBarActionButtonPressed,
      );
    }

    // build appbar
    return AppBar(
      title: Text(title),
      actions: <Widget>[actionBtn],
      elevation: 4,
    );
  }

  void onAppBarActionButtonPressed() {
    AppFrameEvent event = AppFrameEvent(switchTo: FrameTabType.MENU);
    bloc.eventSink.add(event);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
