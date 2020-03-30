import 'package:flutter/material.dart';

import 'package:foodbar_user/settings/app_properties.dart';

class AppTheme {
  static ThemeData getData(){
    return ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black
            ),
          textTheme: TextTheme(
            title: TextStyle(color: Colors.black, fontSize: 18),
            )
        ),
        scaffoldBackgroundColor: Colors.white,
        disabledColor: Colors.grey,
      );
  }
}