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
  String loginTitle = 'Login';

  static int splashDelayInSeconds = 1;

  static double cardSideMargin = 20;
  static double cardVerticalMargin = 15;
  static double cardElevation = 20;
  static double cardRadius = 20;

  //static double appBarIconSize = 30;

  static int subTitleLength = 70;
  static int descriptionLength = 80;

  static double h1 = 25;
  static double h2 = 22;
  static double h3 = 18;
  static double h4 = 15;
  static double h5 = 14;
  static double p = 12;

  // appframe
  MenuType menuType = MenuType.TwoPage;

  static IconData menuIcon = FoodBarIcons.spoon_and_fork;
  static IconData cartIcon = FoodBarIcons.shopping_bag_not_empty;
  static IconData cartIconEmpty = FoodBarIcons.shopping_bag;
  static IconData reservationIcon = FoodBarIcons.reservation02;
  static IconData oldReservedIcon = FoodBarIcons.reserved01;
  static IconData logoutIcon = Icons.exit_to_app;
  static IconData loinIcon = Icons.exit_to_app;
  static IconData myOrdersIcon = FoodBarIcons.orders;

  // payment
  double deliveryCharges = 30;
  String currency = '\$';

  // img
  String imgPathLogoWide = 'assets/images/logo_wide.png';
  String imgPathLogoVertical = 'assets/images/logo_vertical.png';
  bool logoHasTitleAndSlagon = true;

  // local db
  static String collectionAuth = 'auth';
  static String collectionToken = 'token';
}
