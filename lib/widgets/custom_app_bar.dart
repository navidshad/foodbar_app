import 'package:Foodbar_user/widgets/cart_button.dart';
import 'package:flutter/material.dart';

import 'package:Foodbar_user/bloc/bloc.dart';
import 'package:Foodbar_user/settings/settings.dart';
import 'package:Foodbar_user/utilities/food_bar_icons.dart';
import 'package:Foodbar_user/widgets/widgets.dart';

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
        onTap: () {
          AppFrameEvent event = AppFrameEvent(switchTo: FrameTabType.CART);
          bloc.eventSink.add(event);
        },
      );
    } else {
      actionBtn = FlatButton(
        child: Icon(FoodBarIcons.spoon_and_fork),
        onPressed: () {
          AppFrameEvent event = AppFrameEvent(switchTo: FrameTabType.MENU);
          bloc.eventSink.add(event);
        },
      );
    }

    // build appbar
    return AppBar(
      title: Text(title),
      actions: <Widget>[actionBtn],
      elevation: 4,
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
