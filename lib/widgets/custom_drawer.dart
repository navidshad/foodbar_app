import 'package:flutter/material.dart';

import 'package:Food_Bar/settings/types.dart';
import 'package:Food_Bar/settings/app_properties.dart';
import 'package:Food_Bar/bloc/bloc.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  AppFrameBloc bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<AppFrameBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    double lohoHeight = 70;

    Image logo = Image.asset(
      AppProperties.imgPath_logo,
      height: lohoHeight,
    );

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
                            children: <Widget>[
                              Text(
                                AppProperties.title,
                                textScaleFactor: 1.6,
                              ),
                              Text(AppProperties.slagon)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: Text(AppProperties.menuTitle),
                  leading: Icon(AppProperties.menuIcon),
                  onTap: () => switchTab(FrameTabType.MENU),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  title: Text(AppProperties.cartTitle),
                  leading: Icon(AppProperties.cartIcon),
                  onTap: () => switchTab(FrameTabType.CART),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  title: Text(AppProperties.reservationTitle),
                  leading: Icon(AppProperties.reservationIcon),
                  onTap: () => switchTab(FrameTabType.Reserve),
                ),
                Divider(
                  height: 0,
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
