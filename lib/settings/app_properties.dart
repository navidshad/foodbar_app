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
  static String reservationTitle = 'Table Reservation';

  static int splashDelayInSeconds = 5;

  static Color mainColor = Colors.green;
  static Color secondColor = Colors.blue;
  static Color disabledColor = Colors.grey[100];
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
  static IconData reservationIcon = FoodBarIcons.reservation02;

  // payment
  static double deliveryCharges = 30;

  // img
  static String imgPathLogoWide = 'assets/images/logo_wide.png';
  static String imgPathLogoVertical = 'assets/images/logo_vertical.png';
  static bool logoHasTitleAndSlagon = true;
}