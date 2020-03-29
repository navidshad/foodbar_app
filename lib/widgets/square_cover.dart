import 'package:flutter/material.dart';

class SquareCover extends StatelessWidget {
  const SquareCover({
    Key key,
    @required this.boxFit,
    @required this.url,
    @required this.sideSize,
  }) : super(key: key);

  final BoxFit boxFit;
  final String url;
  final double sideSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (con, constraints) {
        return Container(
          width: sideSize,
          height: sideSize,
          child: Image.network(
          url,
          fit: boxFit,
          width: constraints.biggest.width,
          height: constraints.biggest.height,
        ),
        );
      },
    );
  }
}
