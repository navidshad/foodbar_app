import 'package:flutter/material.dart';

import 'package:Food_Bar/settings/app_properties.dart';
import 'package:Food_Bar/utilities/date_util.dart';

class CardDay extends StatelessWidget {
  CardDay(
      {Key key,
      this.date,
      this.margin,
      this.backgroundColor,
      this.textColor,
      this.disableColor = Colors.grey,
      this.disableTextColor = Colors.black,
      this.isActive = false,
      this.onPressed})
      : super(key: key);

  final DateTime date;
  final EdgeInsets margin;
  final Color backgroundColor;
  final Color textColor;
  final Color disableColor;
  final Color disableTextColor;
  final bool isActive;
  final Function(DateTime date) onPressed;

  @override
  Widget build(BuildContext context) {
    double width = 75;
    double height = 90;

    Color tempBackColor = (isActive) ? backgroundColor : disableColor;
    Color tempTextColor = (isActive) ? textColor : disableTextColor;

    Widget body = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: tempBackColor),
      padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            DateUtil.shortWeekDays[date.weekday],
            textScaleFactor: 0.9,
            style: TextStyle(color: tempTextColor),
          ),
          Text(
            date.day.toString(),
            textScaleFactor: 2,
            style: TextStyle(color: tempTextColor),
          )
        ],
      ),
    );

    return InkWell(
      child: body,
      borderRadius: BorderRadius.all(Radius.circular(15)),
      onTap: (){ onPressed(date); },
    );
  }
}
