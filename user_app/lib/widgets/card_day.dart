import 'package:flutter/material.dart';

import 'package:foodbar_flutter_core/utilities/date_util.dart';

class CardDay extends StatelessWidget {
  CardDay(
      {Key key, this.date, this.margin, this.isActive = false, this.onPressed})
      : super(key: key);

  final DateTime date;
  final EdgeInsets margin;
  Color backgroundColor;
  Color textColor;
  Color disableColor;
  Color disableTextColor;
  final bool isActive;
  final Function(DateTime date) onPressed;

  List<BoxShadow> shadows = [
    BoxShadow(color: Colors.white12, blurRadius: 10, spreadRadius: 3),
  ];

  @override
  Widget build(BuildContext context) {
    backgroundColor = Theme.of(context).colorScheme.secondaryVariant;
    textColor = Theme.of(context).colorScheme.onSecondary;
    disableColor = Theme.of(context).colorScheme.secondary;
    disableTextColor = Theme.of(context).colorScheme.onSecondary;

    Color tempBackColor = (isActive) ? backgroundColor : disableColor;
    Color tempTextColor = (isActive) ? textColor : disableTextColor;

    Widget body = Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: tempBackColor,
        //boxShadow: isActive ? shadows : [],
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                date.day.toString(),
                textScaleFactor: 2,
                style: TextStyle(color: tempTextColor),
              ),
              Text(
                DateUtil.shortWeekDays[date.weekday],
                textScaleFactor: 0.95,
                style: TextStyle(color: tempTextColor),
              ),
            ],
          ),
        ),
      ),
    );

    return InkWell(
      child: body,
      borderRadius: BorderRadius.all(Radius.circular(15)),
      onTap: () {
        onPressed(date);
      },
    );
  }
}
