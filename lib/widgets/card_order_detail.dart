import 'package:flutter/material.dart';
import 'package:Foodbar_user/settings/app_properties.dart';

class CardOrderDetail extends StatelessWidget {
  const CardOrderDetail({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget body;

    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: body,
      ),
      margin: EdgeInsets.only(bottom: AppProperties.cardVerticalMargin),
      elevation: AppProperties.cardElevation,
    );
  }
}
