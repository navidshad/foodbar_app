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
  static String myOrdersTitle = 'My Orders';
  static String oldReservedTitle = 'Old Reserved';
  static String logoutTitle = 'Logout';


  static int splashDelayInSeconds = 1;

  static Color mainColor = Colors.lightGreen;
  static Color secondColor = Colors.blue;
  static Color disabledColor = Colors.grey[100];
  static Color backLightColor = Color.fromRGBO(255, 240, 225, 1);
  
  static Color textOnMainColor = Colors.white;
  static Color textOnDisabled  = Colors.black;
  static Color textOnBackLight  = Colors.black;

  static double cardSideMargin = 15;
  static double cardVerticalMargin = 2;
  
  // appframe
  static MenuType menuType = MenuType.TwoPage;

  static IconData menuIcon = FoodBarIcons.spoon_and_fork;
  static IconData cartIcon = FoodBarIcons.shopping_bag_not_empty;
  static IconData cartIconEmpty = FoodBarIcons.shopping_bag;
  static IconData reservationIcon = FoodBarIcons.reservation02;
  static IconData oldReservedIcon = FoodBarIcons.reserved01;
  static IconData logoutIcon = Icons.exit_to_app;
  static IconData myOrdersIcon = FoodBarIcons.orders;

  // payment
  static double deliveryCharges = 30;

  // img
  static String imgPathLogoWide = 'assets/images/logo_wide.png';
  static String imgPathLogoVertical = 'assets/images/logo_vertical.png';
  static bool logoHasTitleAndSlagon = true;

  // local db
  static String collectionAuth = 'auth';
  static String collectionToken = 'token';

}