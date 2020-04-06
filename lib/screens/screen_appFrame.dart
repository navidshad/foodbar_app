import 'package:foodbar_user/screens/screens.dart';
import 'package:flutter/material.dart';

import 'package:foodbar_user/bloc/bloc.dart';
import 'package:foodbar_user/settings/settings.dart';
import 'package:foodbar_user/widgets/widgets.dart';
import 'package:foodbar_user/screens/tab_menu.dart';

class AppFrame extends StatefulWidget {
  @override
  _AppFrameState createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame> with TickerProviderStateMixin {
  AppFrameBloc bloc;
  FrameTabType currentTab;
  TabController _tabController;
  ThemeData theme;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
    _tabController.addListener(onTabViewChanged);
  }

  onChangeBckGround(ColorSwicher swicher) {
    theme = Theme.of(context).copyWith(
      backgroundColor: swicher.color,
      scaffoldBackgroundColor: swicher.color,
      appBarTheme: AppBarTheme(
        color: swicher.color,
        elevation: 0,
        textTheme: TextTheme(
            title: TextStyle(
          color: swicher.onColor,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        )),
        actionsIconTheme: IconThemeData(
          color: swicher.onColor,
          size: 25,
        ),
        iconTheme: IconThemeData(
          color: swicher.onColor,
          size: 25,
        ),
      ),
    );
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<AppFrameBloc>(context);
    bloc.colorStream.listen(onChangeBckGround);
  }

  @override
  Widget build(BuildContext context) {
    if (theme == null) theme = Theme.of(context);

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: CustomAppBar(),
        drawer: CustomDrawer(),
        body: StreamBuilder<AppFrameState>(
          stream: bloc.stateStream,
          initialData: bloc.getInitialState(),
          builder: (stateContext, AsyncSnapshot<AppFrameState> snapshot) {
            currentTab = AppFrameBloc.currentType; //snapshot.data.type;

            _tabController.index = getTypeIndex(currentTab);

            return TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                BlocProvider(
                  child: MenuTab(),
                  bloc: MenuBloc(),
                ),

                // cartBloc was provided by the route of this page
                CartTab(),

                ReservationTab(),

                BlocProvider(
                  bloc: ReservedBloc(),
                  child: OldReserved(),
                ),

                BlocProvider(
                  bloc: OrderBloc(),
                  child: OrdersTab(),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  int getTypeIndex(FrameTabType type) {
    if (type == FrameTabType.MENU)
      return 0;
    else if (type == FrameTabType.CART)
      return 1;
    else if (type == FrameTabType.RESERVATION)
      return 2;
    else if (type == FrameTabType.RESERVED)
      return 3;
    else if (type == FrameTabType.ORDERS)
      return 4;
    else
      return 0;
  }

  void onTabViewChanged() {
    //FrameTabType type = AppFrameBloc.switchType(currentTab);
    //sbloc.add(ChangeAppBarAppFrameEvent(type));
  }

  void switchTab(FrameTabType type) {
    //bloc.eventSink.add(AppFrameEvent(type));
    _tabController.index = getTypeIndex(currentTab);
  }

  @override
  void dispose() {
    //bloc.dispose();
    super.dispose();
  }
}
