import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:Food_Bar/utilities/date_util.dart';

class CardTime extends StatelessWidget {
  CardTime(
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

    DateFormat formatedDate = DateFormat.jm();
    String time = formatedDate.format(date);

    Widget body = Container(
      width: width,
      height: height,
//      margin: margin,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          //borderRadius: BorderRadius.all(Radius.circular(15)),
          color: tempBackColor),
      //padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            time.split(' ')[0],
            textScaleFactor: 1,
            style: TextStyle(color: tempTextColor),
          ),
          Text(
            time.split(' ')[1],
            textScaleFactor: 0.5,
            style: TextStyle(color: tempTextColor),
          )
        ],
      ),
    );

    return Container(
      margin: margin,
      child: InkWell(
        child: body,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        onTap: () {
          onPressed(date);
        },
      ),
    );
  }
}
