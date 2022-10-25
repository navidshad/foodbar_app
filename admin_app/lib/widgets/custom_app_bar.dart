import 'package:flutter/material.dart';

import 'package:foodbar_admin/bloc/bloc.dart';
import 'package:foodbar_admin/settings/settings.dart';
import 'package:foodbar_admin/utilities/food_bar_icons.dart';
import 'package:foodbar_admin/widgets/widgets.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(55);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late FrameTabType currentTab;
  AppFrameBloc? bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<AppFrameBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc!.stateStream,
      initialData: bloc!.getInitialState(),
      builder: (stateContext, AsyncSnapshot<AppFrameState> snapshot) {
        return buildAppBar(snapshot.data!.title, AppFrameBloc.currentType);
      },
    );
  }

  AppBar buildAppBar(String title, FrameTabType type) {
    Widget actionBtn;
    currentTab = type;

    // build appbar
    return AppBar(
      title: Text(title),
      actions: <Widget>[],
      elevation: 4,
    );
  }

  @override
  void dispose() {
    bloc!.dispose();
    super.dispose();
  }
}
