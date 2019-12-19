import 'package:flutter/material.dart';
import 'package:Food_Bar/settings/types.dart';

/// All default values are here, texts, colorsand etc
class AppProperties {
  
  // general
  static String title = 'Food Bar';
  static String slagon = 'Eat Your Taste';
  
  static String menuTitle = 'Menu';
  static String cartTitle = 'My Cart';

  static int splashDelay = 5;
  
  // appframe
  static MenuType menuType = MenuType.OnePage;

  static double cardSideMargin = 15;
  static double cardVerticalMargin = 5;

  static Color mainColor = Colors.green;
  static Color backLightColor = Color.fromRGBO(255, 240, 225, 1);
}