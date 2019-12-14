import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/settings/settings.dart';
import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/screens/menu_tab.dart';

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
  Widget build(BuildContext context) {
    print('build appframe');

    bloc = BlocProvider.of<AppFrameBloc>(context);

    Scaffold scaffold = Scaffold(
      appBar: CustomAppBar(),
      body: buildFrameBloc()
    );

    return scaffold;
  }

  Widget buildFrameBloc()
  {
    return BlocBuilder(
      bloc: bloc,
      condition: (stateContext, AppFrameState state) {
        return (state is ShowingTabAppFrameState) ? true : false;
      },
      builder: (stateContext, AppFrameState state) {

        currentTab = state.tabType;
        
        if (state is ShowingTabAppFrameState)
          _tabController.index = getTypeIndex(state.tabType);

        return TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Center(
              child: MenuTab(),
            ),
            Center(
              child: Text('Cart'),
            )
          ],
        );

      },
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
  void dispose(){
    bloc.close();
    super.dispose();
  }
}
