import 'package:flutter/material.dart';

import 'package:foodbar_user/settings/types.dart';
import 'package:foodbar_user/settings/app_properties.dart';
import 'package:foodbar_user/bloc/bloc.dart';
import 'package:foodbar_user/services/options_service.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  AppFrameBloc bloc;
  OptionsService options = OptionsService.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<AppFrameBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    double lohoHeight = 70;

    Image logo = Image.asset(
      options.properties.imgPathLogoWide,
      height: lohoHeight,
    );

    List<Widget> titles = [];
    if (!options.properties.logoHasTitleAndSlagon) {
      titles = [
        Text(
          options.properties.title,
          textScaleFactor: 1.6,
        ),
        Text(options.properties.slagon)
      ];
    }

    return StreamBuilder(
      stream: bloc.stateStream,
      initialData: bloc.getInitialState(),
      builder: (context, constrants) {
        return Container(
          margin: EdgeInsets.only(top: 81),
          child: Drawer(
            elevation: 40,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 120,
                  child: DrawerHeader(
                    margin: EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        logo,
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          height: lohoHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: titles,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: Text(options.properties.menuTitle),
                  leading: Icon(AppProperties.menuIcon),
                  onTap: () => switchTab(FrameTabType.MENU),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  title: Text(options.properties.cartTitle),
                  leading: Icon(AppProperties.cartIcon),
                  onTap: () => switchTab(FrameTabType.CART),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  title: Text(options.properties.reservationTitle),
                  leading: Icon(AppProperties.reservationIcon),
                  onTap: () => switchTab(FrameTabType.RESERVATION),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  title: Text(options.properties.oldReservedTitle),
                  leading: Icon(AppProperties.oldReservedIcon),
                  onTap: () => switchTab(FrameTabType.RESERVED),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  title: Text(options.properties.myOrdersTitle),
                  leading: Icon(AppProperties.myOrdersIcon),
                  onTap: () => switchTab(FrameTabType.ORDERS),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  title: Text(options.properties.logoutTitle),
                  leading: Icon(AppProperties.logoutIcon),
                  onTap: () {
                    bloc.authService.logout();
                    Navigator.pushReplacementNamed(context, '/intro');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void switchTab(FrameTabType type) {
    bloc.eventSink.add(AppFrameEvent(switchTo: type));
    Navigator.pop(context);
  }
}
