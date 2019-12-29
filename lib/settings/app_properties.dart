import 'package:flutter/material.dart';
import 'package:Food_Bar/settings/types.dart';
import 'package:Food_Bar/utilities/food_bar_icons.dart';

/// All default values are here, texts, colorsand etc
class AppProperties {
  
  // general
  static String title = 'Food Bar';
  static String slagon = 'Eat Your Taste';
  
  static String menuTitle = 'Menu';
  static String cartTitle = 'My Cart';

  static int splashDelay = 5;

  static Color mainColor = Colors.green;
  static Color disabledColor = Colors.grey;
  static Color backLightColor = Color.fromRGBO(255, 240, 225, 1);
  
  static Color textOnMainColor = Colors.white;
  static Color textOnDisabled  = Colors.black;

  static double cardSideMargin = 15;
  static double cardVerticalMargin = 5;
  
  // appframe
  static MenuType menuType = MenuType.TwoPage;

  static IconData menuIcon = FoodBarIcons.spoon_and_fork;
  static IconData cartIcon = FoodBarIcons.shopping_bag_not_empty;
  static IconData cartIconEmpty = FoodBarIcons.shopping_bag;

  // payment
  static double deliveryChages = 30;
}