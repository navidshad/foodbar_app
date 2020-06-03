import 'package:flutter/material.dart';
import 'package:foodbar_user/widgets/popup_auth_alert.dart';

Future<dynamic> openAuthAlert(BuildContext context) {
  return showDialog(
      context: context,
      builder: (con) {
        return PopupAuthAlert();
      });
}
