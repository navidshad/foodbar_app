import 'package:flutter/material.dart';

class VerticalSwipDetector extends StatelessWidget {
  VerticalSwipDetector({
    Key? key,
    @required this.child,
    @required this.onUpSwip,
    @required this.onDownSwip,
    this.onDone,
  }) : super(key: key);

  final Function onUpSwip;
  final Function onDownSwip;
  final Function onDone;
  final Widget child;

  double verticalDragStartPoint = 0;
  double verticalDragEndPoint = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onVerticalDragStart: (dragStartDetails) {
        verticalDragStartPoint = dragStartDetails.localPosition.dy;
      },
      onVerticalDragUpdate: (dragUpdateDetails) {
        verticalDragEndPoint = dragUpdateDetails.localPosition.dy;
      },
      onVerticalDragEnd: (drageEndDetail) {
        bool isDownSwip = (verticalDragStartPoint > verticalDragEndPoint);

        verticalDragStartPoint = 0;
        verticalDragEndPoint = 0;

        if (isDownSwip)
          onDownSwip();
        else
          onUpSwip();

        if(onDone != null) onDone();
      },
    );
  }
}
