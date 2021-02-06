import 'package:flutter/material.dart';

import 'package:foodbar_admin/services/options_service.dart';

class SplashScreen extends StatelessWidget {

  OptionsService options = OptionsService.instance;

  @override
  Widget build(BuildContext context) {
    // load logo and setup it
    Image logo = Image.asset(
      options.properties.imgPathLogoVertical,
      height: 230,
    );

    List<Widget> columnChilds = [logo];

    // if logo doesnt has Title ans slagon
    // add Title & slagon by text
    if (!options.properties.logoHasTitleAndSlagon) {
      columnChilds.add(Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          children: <Widget>[
            Text(options.properties.title, textScaleFactor: 2),
            Text(options.properties.slagon, textScaleFactor: 1),
          ],
        ),
      ));
    }

    // build splash screen
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: columnChilds,
      ),
    );
  }
}
