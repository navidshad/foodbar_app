import 'package:flutter/material.dart';

import 'package:foodbar_user/settings/app_properties.dart';
import 'package:foodbar_user/utilities/food_bar_icons.dart';

class ConfirmStateViewer extends StatelessWidget {
  ConfirmStateViewer({
    Key key,
    this.isSucceed,
    this.subtitle = '',
    this.processID,
    this.backGroundUrl,
  }) : super(key: key);

  final bool isSucceed;
  final String subtitle;
  final int processID;
  final String backGroundUrl;

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
      // Icon
      // Container(
      //   margin: EdgeInsets.all(20),
      //   child: iconWidget,
      // ),

      // Texts
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.contain,
            child: Text(
              title,
              // textScaleFactor: 1.8,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: AppProperties.h1),
            ),
          ),
          Text(
            subtitle ?? '',
            textAlign: TextAlign.center,
          ),
          if (processID != null)
            Container(
              width: MediaQuery.of(context).size.width / 100 * 50,
              child: Column(children: [
                FittedBox(
                  child: Text(
                    'RID ' + processID.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        decorationStyle: TextDecorationStyle.wavy,
                        letterSpacing: 5,
                        shadows: [Shadow(color: Colors.black, blurRadius: 80)]),
                  ),
                ),
              ]),
            ),
        ],
      ),

      // note text
      FittedBox(
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 100 * 10,
            right: MediaQuery.of(context).size.width / 100 * 10,
          ),
          child: Text(
            'Then, you can chack your reserved tables'.toUpperCase(),
            textAlign: TextAlign.justify,
            style: TextStyle(color: Colors.white, fontSize: AppProperties.p),
          ),
        ),
      )
    ];

    return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Stack(
            children: <Widget>[
              Container(
                // color: Colors.pink,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(backGroundUrl ?? ''),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).disabledColor,
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                top: 30,
                bottom: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: body,
                ),
              )
            ],
          ),
        ));
  }
}
