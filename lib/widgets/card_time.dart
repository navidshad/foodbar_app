import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:foodbar_flutter_core/utilities/date_util\.dart';

class CardTime extends StatelessWidget {
  CardTime(
      {Key key,
      this.date,
      this.margin,
      // this.backgroundColor,
      // this.textColor,
      // this.disableColor = Colors.grey,
      // this.disableTextColor = Colors.black,
      this.isActive = false,
      this.isReserved = false,
      this.onPressed})
      : super(key: key);

  final DateTime date;
  final EdgeInsets margin;
  Color backgroundColor;
  Color textColor;
  Color disableColor;
  Color disableTextColor;
  final bool isActive;
  final bool isReserved;
  final Function(DateTime date) onPressed;

  @override
  Widget build(BuildContext context) {
    double width = 75;
    double height = 90;

    backgroundColor = Theme.of(context).backgroundColor;
    textColor = Theme.of(context).colorScheme.onBackground;
    disableColor = Theme.of(context).colorScheme.error;
    disableTextColor = Theme.of(context).colorScheme.onError;

    Color tempBackColor = (isActive) ? backgroundColor : disableColor;
    Color tempTextColor = (isActive) ? textColor : disableTextColor;

    DateFormat formatedDate = DateFormat.jm();
    String time = formatedDate.format(date);

    // card body
    Widget body = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(shape: BoxShape.circle, color: tempBackColor),
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

    // stack
    List<Widget> stackBody = [body];

    if (isReserved) {
      Widget reservedWidget = Container(
        width: width,
        height: 28,
        color: Colors.red[200],
        child: Text(
          'Reserved'.toUpperCase(),
          textScaleFactor: 0.8,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      );

      stackBody.add(reservedWidget);
    }

    Widget stack = Stack(
      children: stackBody,
      alignment: AlignmentDirectional.bottomCenter,
    );

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        child: InkWell(
          child: stack,
          borderRadius: BorderRadius.all(Radius.circular(1000)),
          onTap: () {
            if (!isReserved) onPressed(date);
          },
        ),
      ),
    );
  }
}
