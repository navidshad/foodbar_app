import 'package:flutter/material.dart';
import 'package:foodbar_admin/settings/types.dart';
import 'package:foodbar_admin/utilities/food_bar_icons.dart';

class TabDetail {
  String title;
  IconData icon;

  TabDetail({required this.icon, required this.title});
}

/// All default values are here, texts, colorsand etc
class AppProperties {
  // general
  String title = 'Food Bar Admin';
  String slagon = 'Eat Your Taste';

  String logoutTitle = 'Logout';

  Map<FrameTabType, TabDetail> tabDetails = {
    FrameTabType.DASHBOARD: TabDetail(
      title: 'Dashboard',
      icon: Icons.dashboard,
    ),
    FrameTabType.ORDERS: TabDetail(
      title: 'Orders',
      icon: FoodBarIcons.orders,
    ),
    FrameTabType.RESERVED: TabDetail(
      title: 'Reserved Tables',
      icon: FoodBarIcons.reserved01,
    ),
    FrameTabType.COUPEN: TabDetail(
      title: 'Coupens',
      icon: Icons.card_membership,
    ),
    FrameTabType.STATISTICS: TabDetail(
      title: 'Statistics',
      icon: Icons.insert_chart,
    ),
    FrameTabType.FOODS: TabDetail(
      title: 'Foods',
      icon: FoodBarIcons.spoon_and_fork,
    ),
    FrameTabType.CATEGORIES: TabDetail(
      title: 'Categories',
      icon: FoodBarIcons.spoon_and_fork,
    ),
    FrameTabType.INTRO_SLIDES: TabDetail(
      title: 'Intro Slides',
      icon: Icons.slideshow,
    ),
    FrameTabType.TABLES: TabDetail(
      title: 'Tables',
      icon: FoodBarIcons.reserved01,
    ),
    FrameTabType.PERIODS: TabDetail(
      title: 'Periods',
      icon: Icons.access_time,
    ),
    FrameTabType.USERS: TabDetail(
      title: 'Users',
      icon: Icons.supervised_user_circle,
    ),
    FrameTabType.SETTINGS: TabDetail(title: 'Settings', icon: Icons.settings),
  };

  static int splashDelayInSeconds = 1;

  static Color mainColor = Colors.lightGreen;
  static Color secondColor = Colors.blue;
  static Color disabledColor = Colors.grey[100]!;
  static Color backLightColor = Color.fromRGBO(255, 240, 225, 1);

  static Color textOnMainColor = Colors.white;
  static Color textOnDisabled = Colors.black;
  static Color textOnBackLight = Colors.black;

  static double cardSideMargin = 20;
  static double cardVerticalMargin = 15;
  static double cardElevation = 30;

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

  // mongo db
  static int mongodbTotalPerPage = 10;
}
