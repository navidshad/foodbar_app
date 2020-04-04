import 'package:flutter/material.dart';

import 'package:foodbar_user/settings/app_properties.dart';

class AppTheme {
  static ThemeData getData() {
    ThemeData theme = ThemeData.from(
        colorScheme: ColorScheme(
      primary: Color.fromRGBO(198, 213, 103, 1),//Colors.lightGreenAccent[400],
      primaryVariant: Color.fromRGBO(155, 167, 81, 1),//Colors.green[900],
      secondary: Color.fromRGBO(136, 63, 65, 1),//Colors.lightBlue,
      secondaryVariant: Color.fromRGBO(66, 20, 21, 1),//Colors.blue[900],
      surface: Colors.grey[100],
      background: Colors.grey[200],
      error: Colors.redAccent,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.grey[900],
      onBackground: Colors.black87,
      onError: Colors.white,
      brightness: Brightness.light,
    ));

    theme = theme.copyWith(
      buttonColor: theme.colorScheme.secondary,
      splashColor: theme.colorScheme.secondaryVariant,
      buttonTheme: ButtonThemeData(
        buttonColor: theme.colorScheme.secondary,
        shape: RoundedRectangleBorder(),
        splashColor: theme.colorScheme.secondaryVariant,
        textTheme: ButtonTextTheme.normal,
        disabledColor: theme.disabledColor
      ),
      appBarTheme: AppBarTheme(
        textTheme: TextTheme(
          title: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          )
        ),
        actionsIconTheme: IconThemeData(
          color: theme.colorScheme.onPrimary,
          size: 25,
        ),
        iconTheme: IconThemeData(
          color: theme.colorScheme.onPrimary,
          size: 25,
        ),
      )
    );

    return theme;
    // return ThemeData(
    //     primarySwatch: Colors.green,
    //     appBarTheme: AppBarTheme(
    //       color: Colors.white,
    //       iconTheme: IconThemeData(
    //         color: Colors.black
    //         ),
    //       textTheme: TextTheme(
    //         title: TextStyle(color: Colors.black, fontSize: 18),
    //         )
    //     ),
    //     scaffoldBackgroundColor: Colors.white,
    //     disabledColor: Colors.grey,
    //   );
  }
}
