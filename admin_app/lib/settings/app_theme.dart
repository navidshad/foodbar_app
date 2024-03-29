import 'package:flutter/material.dart';

import 'package:foodbar_admin/settings/app_properties.dart';

class AppTheme {
  static ThemeData getData() {
    return ThemeData(
      primarySwatch: Colors.pink,
      appBarTheme: AppBarTheme(
        color: AppProperties.backLightColor,
        iconTheme: IconThemeData(color: Colors.black),
        // textTheme: TextTheme(
        //   title: TextStyle(color: Colors.black, fontSize: 18),
        //   )
      ),
      scaffoldBackgroundColor: Colors.white,
      disabledColor: Colors.grey,
    );
  }
}
