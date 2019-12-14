import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getData(){
    return ThemeData(
        primarySwatch: Colors.pink,
        appBarTheme: AppBarTheme(
          color: Colors.pink[50],
          iconTheme: IconThemeData(
            color: Colors.black
            ),
          textTheme: TextTheme(
            title: TextStyle(color: Colors.black, fontSize: 18),
            )
        )
      );
  }
}