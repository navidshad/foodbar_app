import 'package:flutter/material.dart';

class SquareCover extends StatelessWidget {
  SquareCover({
    Key key,
    @required this.boxFit,
    @required this.url,
    // double sideSize,
    this.width,
    this.height,
  }) : super(key: key);

  final BoxFit boxFit;
  final String url;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.network(
        url,
        fit: boxFit,
        width: width,
        height: height,
      );
  }
}
