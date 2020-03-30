import 'package:flutter/material.dart';
import 'package:foodbar_flutter_core/settings/types.dart';
import 'package:foodbar_user/utilities/food_bar_icons.dart';

/// All default values are here, texts, colorsand etc
class AppProperties {
  // general
  String title = 'Food Bar';
  String slagon = 'Eat Your Taste';

  String menuTitle = 'Menu';
  String cartTitle = 'My Cart';
  String reservationTitle = 'Table Reservation';
  String myOrdersTitle = 'My Orders';
  String oldReservedTitle = 'Old Reserved';
  String logoutTitle = 'Logout';

  static int splashDelayInSeconds = 1;

  static Color mainColor = Colors.lightGreen;
  static Color secondColor = Colors.blue;
  static Color disabledColor = Colors.grey[100];
  static Color backLightColor = Color.fromRGBO(255, 240, 225, 1);

  static Color textOnMainColor = Colors.white;
  static Color textOnDisabled = Colors.black;
  static Color textOnBackLight = Colors.black;

  static double cardSideMargin = 20;
  static double cardVerticalMargin = 15;
  static double cardElevation = 30;
  static double cardRadius = 10;

  static int subTitleLength = 70;
  static int descriptionLength = 80;

  static double h1 = 30;
  static double h2 = 25;
  static double h3 = 20;
  static double h4 = 16;
  static double h5 = 15;
  static double p = 14;

  // appframe
  MenuType menuType = MenuType.TwoPage;

  static IconData menuIcon = FoodBarIcons.spoon_and_fork;
  static IconData cartIcon = FoodBarIcons.shopping_bag_not_empty;
  static IconData cartIconEmpty = FoodBarIcons.shopping_bag;
  static IconData reservationIcon = FoodBarIcons.reservation02;
  static IconData oldReservedIcon = FoodBarIcons.reserved01;
  static IconData logoutIcon = Icons.exit_to_app;
  static IconData myOrdersIcon = FoodBarIcons.orders;

  // payment
  double deliveryCharges = 30;

  // img
  String imgPathLogoWide = 'assets/images/logo_wide.png';
  String imgPathLogoVertical = 'assets/images/logo_vertical.png';
  bool logoHasTitleAndSlagon = true;

  // local db
  static String collectionAuth = 'auth';
  static String collectionToken = 'token';
}
