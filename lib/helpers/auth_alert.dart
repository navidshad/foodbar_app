import 'package:flutter/material.dart';
import 'package:foodbar_user/widgets/popup.dart';
import 'package:foodbar_user/widgets/popup_auth_alert.dart';
import 'package:foodbar_user/widgets/widgets.dart';

Future<dynamic> openAuthAlert(BuildContext context) {
  return showDialog(
      context: context,
      builder: (con) {
        return PopupAuthAlert();
      });
}

Future<dynamic> openCloseTimeAlert(BuildContext context) {
  print('### openCloseTimeAlert');
  return showDialog(
      context: context,
      builder: (con) {
        return Popup(
          bodyContent: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('''Alla kära gäster 
midsommar afton & midsommar dagen restaurangen är stängda
Söndag den 21e Juni är öppet som vanligt från kl 12.00 till 17.00
Trevligt helg'''),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: 150,
                  height: 45,
                  child: StatusButton(
                    title: 'Ok',
                    onTap: (completer) => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
