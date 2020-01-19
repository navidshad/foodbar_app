import 'package:flutter/material.dart';

import 'package:Food_Bar/settings/app_properties.dart';
import 'package:Food_Bar/utilities/food_bar_icons.dart';

class ConfirmStateViewer extends StatelessWidget {
  const ConfirmStateViewer({Key key, this.isSucceed, this.subtitle = ''})
      : super(key: key);

  final bool isSucceed;
  final String subtitle;

  @override
  Widget build(BuildContext context) {

    String title = (isSucceed) ? 'Thank You!' : 'Sorry... !';
    
    Widget iconWidget;
    if(isSucceed) {
      iconWidget = Icon(FoodBarIcons.success, color: Colors.green, size: 100,);
    } else {
      iconWidget = Icon(FoodBarIcons.error, color: Colors.red, size: 100,);
    }

    List<Widget> body = [

      Container(
        margin: EdgeInsets.all(50),
        child: iconWidget,
      ),

      Text(title, textScaleFactor: 1.8, style: TextStyle(
        fontWeight: FontWeight.bold
      ),),
      Text(subtitle ?? ''),

    ];

    return Container(
      height: 300,
      color: AppProperties.backLightColor,
      child: Column(
        children: body,
      ),
    );
  }
}
