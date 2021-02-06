import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final double elevation;
  final double radius;
  final double height;
  final String title;
  final Function onTap;
  final bool isOutline;
  final EdgeInsets margin;

  final Color mainColor;
  final Color disabledColor;
  final Color textOnMainColor;
  final Color textOnDisabled;

  CardButton(
      {this.elevation,
      this.radius = 5,
      this.title,
      this.height,
      this.onTap,
      this.isOutline = false,
      this.margin,
      @required this.mainColor,
      @required this.disabledColor,
      @required this.textOnDisabled,
      @required this.textOnMainColor});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (layoutContext, constraints) {
        Widget button;

        if (isOutline) {
          button = OutlineButton(
            onPressed: onTap,
            borderSide: BorderSide(color: mainColor),
            disabledBorderColor: disabledColor,
            disabledTextColor: textOnDisabled,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
          );
        } else {
          button = FlatButton(
            onPressed: onTap,
            color: mainColor,
            disabledColor: disabledColor,
            disabledTextColor: textOnDisabled,
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textOnMainColor),
            ),
          );
        }

        return Container(
          margin: margin,
          height: height,
          width: constraints.minWidth,
          child: button,
        );
      },
    );
  }
}
