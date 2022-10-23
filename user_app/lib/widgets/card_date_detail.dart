import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:foodbar_flutter_core/utilities/date_util\.dart';

class CardDateDetail extends StatelessWidget {
  CardDateDetail({
    Key? key,
    this.width,
    this.height,
    this.date,
    this.margin,
    this.backgroundColor,
    this.backgroundColor2,
    this.textColor,
  }) : super(key: key);

  final double width;
  final double height;
  final DateTime date;
  final EdgeInsets margin;
  // final Function(DateTime date) onPressed;
  final Color backgroundColor;
  final Color backgroundColor2;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    String dateStr = DateFormat.MMMEd().format(date);
    String time = DateFormat.jm().format(date);

    // card body
    Widget body = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: backgroundColor2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: height / 3 * 1,
            color: Color.fromRGBO(
              backgroundColor.red,
              backgroundColor.green,
              backgroundColor.blue,
              0.5,
            ),
            alignment: Alignment.bottomCenter,
            child: Text(
              dateStr.split(',')[0],
              textScaleFactor: 2,
              style: TextStyle(color: textColor),
            ),
          ),
          Container(
            height: height / 3 * 1,
            color: Color.fromRGBO(
              backgroundColor.red,
              backgroundColor.green,
              backgroundColor.blue,
              0.5,
            ),
            alignment: Alignment.topCenter,
            child: Text(
              dateStr.split(',')[1],
              textScaleFactor: 1.3,
              style: TextStyle(color: textColor),
            ),
          ),
          Container(
            height: height / 3,
            // color: backgroundColor,
            child: Center(
              child: Text(
                time,
                textScaleFactor: 1,
                style: TextStyle(color: textColor),
              ),
            ),
          )
        ],
      ),
    );

    // stack
    List<Widget> stackBody = [body];

    Widget stack = Stack(
      children: stackBody,
      alignment: AlignmentDirectional.bottomCenter,
    );

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: stack,
      ),
    );
  }
}
