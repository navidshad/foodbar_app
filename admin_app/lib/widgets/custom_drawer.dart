import 'package:flutter/material.dart';

import 'package:foodbar_admin/settings/types.dart';
import 'package:foodbar_admin/settings/app_properties.dart';
import 'package:foodbar_admin/bloc/bloc.dart';
import 'package:foodbar_admin/services/options_service.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late AppFrameBloc bloc;
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
        // create Menu Items
        List<Widget> menuItems = [];
        for (FrameTabType type in options.properties.tabDetails.keys) {
          TabDetail detail = options.properties.tabDetails[type] as TabDetail;

          menuItems.add(ListTile(
            title: Text(detail.title),
            leading: Icon(detail.icon),
            onTap: () => switchTab(type),
          ));

          menuItems.add(Divider(height: 0));
        }

        return Container(
          margin: EdgeInsets.only(top: 81),
          child: Drawer(
            elevation: 40,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                //header ----------------------
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

                // items ----------------------
                for (Widget item in menuItems) item,

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
