import 'package:flutter/material.dart';

import 'package:Food_Bar/settings/app_properties.dart';

class CardButton extends StatelessWidget {
  double elevation;
  double radius;
  double height;
  String title;
  Function onTap;
  bool isOutline;
  EdgeInsets margin;

  CardButton(
      {this.elevation,
      this.radius = 5,
      this.title,
      this.height,
      this.onTap,
      this.isOutline = false,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (layoutContext, constraints) {
        Widget button;

        if (isOutline) {
          button = OutlineButton(
            onPressed: onTap,
            borderSide: BorderSide(color: AppProperties.mainColor),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppProperties.mainColor,
              ),
            ),
          );
        } else {
          button = FlatButton(
            onPressed: onTap,
            color: AppProperties.mainColor,
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppProperties.textOnMainColor),
            ),
          );
        }

        // return Card(
        //   elevation: elevation,
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.all(Radius.circular(radius)),
        //     child: Container(
        //       height: height,
        //       width: constraints.minWidth,
        //       child: button,
        //     ),
        //   ),
        // );

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
