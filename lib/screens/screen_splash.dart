import 'package:flutter/material.dart';

import 'package:Food_Bar/settings/app_properties.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // set a timer for opening home screen after it.
    startTimer(context);

    // load logo and setup it
    Image logo = Image.asset(AppProperties.imgPath_logo, height: 230,);

    // build splash screen
    return Scaffold(
      backgroundColor: AppProperties.backLightColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            // image
            logo,
            
            // text
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Column(
                children: <Widget>[
                  Text(AppProperties.title, textScaleFactor: 2),
                  Text(AppProperties.slagon, textScaleFactor: 1),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  void startTimer(BuildContext context) async {
    new Future.delayed(Duration(seconds: AppProperties.splashDelay))
      .whenComplete(() => Navigator.pushReplacementNamed(context, '/home'));
  }
}
