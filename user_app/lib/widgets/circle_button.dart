import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  CircleButton({
    Key? key,
    this.size,
    this.child,
    this.ontap,
  }) : super(key: key);

  double size;
  Widget child;
  Function ontap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Container(
            width: size,
            height: size,
            child: child,
          ),
          onTap: ontap,
        ),
      ),
    );
  }
}
