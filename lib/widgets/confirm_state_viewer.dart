import 'package:flutter/material.dart';

import 'package:Food_Bar/settings/app_properties.dart';
import 'package:Food_Bar/utilities/food_bar_icons.dart';

class ConfirmStateViewer extends StatelessWidget {
  ConfirmStateViewer(
      {Key key, this.isSucceed, this.subtitle = '', this.processID})
      : super(key: key);

  final bool isSucceed;
  final String subtitle;
  final int processID;

  @override
  Widget build(BuildContext context) {
    String title = (isSucceed) ? 'Thank You!' : 'Sorry... !';

    Widget iconWidget;
    if (isSucceed) {
      iconWidget = Icon(
        FoodBarIcons.success,
        color: Colors.green,
        size: 100,
      );
    } else {
      iconWidget = Icon(
        FoodBarIcons.error,
        color: Colors.red,
        size: 100,
      );
    }

    List<Widget> body = [
      Container(
        margin: EdgeInsets.all(50),
        child: iconWidget,
      ),
      Text(
        title,
        textScaleFactor: 1.8,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        subtitle ?? '',
        textAlign: TextAlign.center,
      ),
      
      if (processID != null)
        Container(
          margin: EdgeInsets.all(20),
          child: Text(
            processID.toString(),
            textScaleFactor: 3,
            style: TextStyle(
                color: Colors.white,
                decorationStyle: TextDecorationStyle.wavy,
                letterSpacing: 5,
                shadows: [Shadow(color: Colors.black, blurRadius: 80)]),
          ),
        )
    ];

    return Container(
      //height: 380,
      padding: EdgeInsets.only(left: 30, right: 30),
      color: AppProperties.backLightColor,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: body,
      ),
    );
  }
}
