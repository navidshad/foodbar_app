import 'package:flutter/material.dart';

import 'package:foodbar_user/settings/app_properties.dart';

class CardButton extends StatelessWidget {
  final double elevation;
  final double radius;
  final double height;
  final String title;
  final Function onTap;
  final bool isOutline;
  final EdgeInsets margin;

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
            borderSide: BorderSide(
              color: Theme.of(context).buttonColor
            ),
            //disabledColor: Theme.of(context).disabledColor,
            // disabledTextColor: AppProperties.textOnDisabled,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                // color: AppProperties.mainColor,
              ),
            ),
          );
        } else {
          button = FlatButton(
            onPressed: onTap,
            color: Theme.of(context).buttonColor,
            disabledColor: Theme.of(context).disabledColor,
            // disabledTextColor: AppProperties.textOnDisabled,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
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
