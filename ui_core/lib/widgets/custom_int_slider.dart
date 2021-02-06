import 'package:flutter/material.dart';

class CustomIntSlider extends StatefulWidget {
  CustomIntSlider(
      {Key key,
      this.title,
      this.min = 0,
      this.max,
      this.divisions,
      @required this.textColor,
      @required this.onChanged})
      : super(key: key);

  final Function(int value) onChanged;

  /// <= 0 >= 1
  final double min, max;
  final int divisions;
  final String title;

  final Color textColor;

  @override
  _CustomIntSliderState createState() => _CustomIntSliderState();
}

class _CustomIntSliderState extends State<CustomIntSlider> {
  double currentValue;

  @override
  Widget build(BuildContext context) {
    // stack section for custom slider ------------------------------
    List<Widget> stackChilds = [];
    currentValue = currentValue ?? widget.min;

    // slider
    Slider slider = Slider(
      key: widget.key,
      divisions: widget.divisions,
      value: currentValue,
      max: widget.max,
      min: widget.min,
      onChanged: (value) => setState(() {
        currentValue = value;
        widget.onChanged(value.toInt());
      }),
    );

    stackChilds.add(slider);

    Stack sliderStack = Stack(
      children: stackChilds,
    );

    // header section -----------------------------------------------
    List<Widget> headerChilds = [];
    if (widget.title != null) {
      headerChilds.add(Text(
        widget.title,
        textScaleFactor: 1.5,
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
      headerChilds.add(Text(
        currentValue.toInt().toString(),
        style: TextStyle(color: widget.textColor),
      ));
    }
    Widget headerRow = Container(
      margin: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: headerChilds,
      ),
    );

    // combine ------------------------------------------------------
    return Column(
      children: <Widget>[headerRow, sliderStack],
    );
  }
}
