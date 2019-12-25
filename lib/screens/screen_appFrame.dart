import 'package:Food_Bar/screens/screens.dart';
import 'package:flutter/material.dart';

import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/settings/settings.dart';
import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/screens/tab_menu.dart';

class AppFrame extends StatefulWidget {
  @override
  _AppFrameState createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame>
    with SingleTickerProviderStateMixin {
  AppFrameBloc bloc;
  FrameTabType currentTab;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(onTabViewChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = AppFrameBlocProvider.of<AppFrameBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    print('build appframe');

    return Scaffold(
      appBar: CustomAppBar(),
      body: StreamBuilder<AppFrameState>(
        stream: bloc.stateStream,
        initialData: bloc.getInitialState(),
        builder: (stateContext, AsyncSnapshot<AppFrameState> snapshot) {
          currentTab = snapshot.data.type;

          _tabController.index = getTypeIndex(currentTab);

          return TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              AppFrameBlocProvider(
                child: MenuTab(),
                bloc: MenuBloc(),
              ),
              AppFrameBlocProvider(
                child: CartTab(),
                bloc: CartBloc(),
              )
            ],
          );
        },
      ),
    );
  }

  int getTypeIndex(FrameTabType type) {
    if (type == FrameTabType.MENU)
      return 0;
    else
      return 1;
  }

  void onTabViewChanged() {
    //FrameTabType type = AppFrameBloc.switchType(currentTab);
    //sbloc.add(ChangeAppBarAppFrameEvent(type));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
