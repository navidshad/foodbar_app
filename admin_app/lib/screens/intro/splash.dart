import 'package:flutter/material.dart';

import 'package:foodbar_admin/services/options_service.dart';

class SplashScreen extends StatelessWidget {
  final OptionsService options = OptionsService.instance;
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;

    _checkFirstEnterAndLoginStatus();

    // load logo and setup it
    Image logo = Image.asset(
      options.properties.imgPathLogoVertical,
      height: 230,
    );

    // build splash screen
    return Scaffold(
      backgroundColor: AppProperties.backLightColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [logo],
        ),
      ),
    );
  }

  void _checkFirstEnterAndLoginStatus() async {
    await Future.delayed(Duration(seconds: AppProperties.splashDelayInSeconds));

    // check first enter to app
    bool firstEnter = false;

    if (firstEnter) {
    } else {
      // goToLoginForm();
      Navigator.of(_context).pushReplacementNamed('/login');
    }
  }
}
