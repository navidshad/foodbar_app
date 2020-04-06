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
  Size get preferredSize => new Size.fromHeight(60);
}

class _CustomAppBarState extends State<CustomAppBar> {
  FrameTabType currentTab;
  AppFrameBloc bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<AppFrameBloc>(context);
  }

  resetBackgroundColor() {
    bloc.colorSink.add(ColorSwicher(
      color: Theme.of(context).colorScheme.background,
      onColor: Theme.of(context).colorScheme.onBackground,
    ));
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
        color: Theme.of(context).appBarTheme.actionsIconTheme.color,
        size: Theme.of(context).appBarTheme.actionsIconTheme.size,
        onTap: () {
          bloc.colorSink.add(ColorSwicher(
            color: Theme.of(context).colorScheme.primary,
            onColor: Theme.of(context).colorScheme.onPrimary,
          ));
          AppFrameEvent event = AppFrameEvent(switchTo: FrameTabType.CART);
          bloc.eventSink.add(event);
        },
      );
    } else {
      actionBtn = FlatButton(
        child: Icon(
          FoodBarIcons.spoon_and_fork,
          color: Theme.of(context).appBarTheme.actionsIconTheme.color,
          size: Theme.of(context).appBarTheme.actionsIconTheme.size,
        ),
        onPressed: () {
          resetBackgroundColor();
          AppFrameEvent event = AppFrameEvent(switchTo: FrameTabType.MENU);
          bloc.eventSink.add(event);
        },
      );
    }

    // build appbar
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppProperties.h4,
        ),
      ),
      actions: <Widget>[actionBtn],
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
