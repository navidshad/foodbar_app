import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  const Popup({Key key, this.bodyContent}) : super(key: key);

  final Widget bodyContent;
  final double width = 100;
  final double height = 200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (con, constraints) {
      double tempWidth = (constraints.maxWidth > width)
          ? width
          : (constraints.maxWidth / 100) * 60;
      double tempHeight = (constraints.maxHeight > height)
          ? height
          : (constraints.maxHeight / 100) * 40;

      double marginX = (constraints.maxWidth - tempWidth) / 4;
      double marginY = (constraints.maxHeight - tempHeight) / 4;

      return Material(
        color: Colors.transparent,
        child: Container(
            padding: EdgeInsets.only(
              top: marginY,
              bottom: marginY,
              left: marginX,
              right: marginX,
            ),
            child: Card(
              child: bodyContent,
              margin: EdgeInsets.all(0),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            )),
      );
    });
  }
}
