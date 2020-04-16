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

  onChangeBckGround(ColorSwiche swiche) {
    theme = Theme.of(context).copyWith(
      backgroundColor: swiche.color,
      scaffoldBackgroundColor: swiche.color,
      appBarTheme: AppBarTheme(
        color: swiche.color,
        elevation: 0,
        textTheme: TextTheme(
            title: TextStyle(
          color: swiche.onColor,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        )),
        actionsIconTheme: IconThemeData(
          color: swiche.onColor,
          size: 25,
        ),
        iconTheme: IconThemeData(
          color: swiche.onColor,
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
    var swiche = ColorSwiche(
      color: Theme.of(context).colorScheme.background,
      onColor: Theme.of(context).colorScheme.onBackground,
    );

    if (currentTab == FrameTabType.CART) {
      swiche = ColorSwiche(
        color: Theme.of(context).colorScheme.primary,
        onColor: Theme.of(context).colorScheme.onPrimary,
      );
    } else if (currentTab == FrameTabType.RESERVATION) {
      swiche = ColorSwiche(
        color: Colors.grey[900],//Theme.of(context).colorScheme.secondaryVariant,
        onColor: Theme.of(context).colorScheme.onSecondary,
      );
    }

    bloc.colorSink.add(swiche);
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
