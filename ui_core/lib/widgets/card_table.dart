import 'package:flutter/material.dart';

import 'package:foodbar_flutter_core/models/models.dart';

class CardTable extends StatelessWidget {
  CardTable(
      {Key key,
      this.table,
      this.margin,
      this.backgroundColor,
      this.textColor,
      this.disableColor = Colors.grey,
      this.disableTextColor = Colors.black,
      this.isActive = false,
      this.onPressed})
      : super(key: key);

  final CustomTable table;
  final EdgeInsets margin;
  final Color backgroundColor;
  final Color textColor;
  final Color disableColor;
  final Color disableTextColor;
  final bool isActive;
  final Function(CustomTable table) onPressed;

  @override
  Widget build(BuildContext context) {
    double width = 90;
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
            table.title,
            textScaleFactor: 0.9,
            style: TextStyle(color: tempTextColor),
          ),
          // Text(
          //   date.day.toString(),
          //   textScaleFactor: 2,
          //   style: TextStyle(color: tempTextColor),
          // )
        ],
      ),
    );

    return InkWell(
      child: body,
      borderRadius: BorderRadius.all(Radius.circular(15)),
      onTap: () {
        onPressed(table);
      },
    );
  }
}
