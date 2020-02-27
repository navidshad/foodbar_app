import 'package:Foodbar_user/settings/settings.dart';
import 'package:flutter/material.dart';

class TextfieldWithIcon extends StatelessWidget {
  final IconData iconData;
  final String hint;
  final bool obscureText;
  final Function(String value) onSubmitted;
  final TextInputType keyboardType;

  TextfieldWithIcon({
    Key key,
    @required this.iconData,
    @required this.onSubmitted,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        Widget row = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                iconData,
                size: 25,
              ),
            ),
            Container(
              width: width - 35,
              height: 50,
              child: TextField(
                style: TextStyle(fontSize: 18),
                onChanged: onSubmitted,
                obscureText: obscureText,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        );

        Column column = Column(
          children: <Widget>[
            row,
            Container(
              height: 1,
              width: width,
              color: Colors.grey,
            )
          ],
        );

        return Container(
          width: width,
          child: column,
        );
      },
    );
  }
}
