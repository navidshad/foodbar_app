import 'package:foodbar_user/widgets/cart_button.dart';
import 'package:flutter/material.dart';

import 'package:foodbar_user/bloc/bloc.dart';
import 'package:foodbar_user/settings/settings.dart';
import 'package:foodbar_user/utilities/food_bar_icons.dart';
import 'package:foodbar_user/widgets/widgets.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(100);
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

  Widget buildAppBar(String title, FrameTabType type) {
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
    return Container(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AppBar(
            title: Text(
              title,
              style: TextStyle(
                fontSize: AppProperties.h4,
              ),
            ),
            actions: <Widget>[actionBtn],
            elevation: 1,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
