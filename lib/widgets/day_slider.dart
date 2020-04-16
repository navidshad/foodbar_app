import 'package:flutter/material.dart';

import 'package:foodbar_user/widgets/widgets.dart';
import 'package:foodbar_user/settings/app_properties.dart';
import 'package:foodbar_flutter_core/utilities/date_util\.dart';

class CustomDaySlider extends StatefulWidget {
  CustomDaySlider({
    Key key,
    @required this.title,
    @required this.height,
    this.totalDays,
    this.from,
    @required this.onDayPicked,
  }) : super(key: key);

  final String title;
  final double height;
  final totalDays;
  final DateTime from;
  final Function(DateTime day) onDayPicked;

  @override
  _CustomDaySliderState createState() => _CustomDaySliderState();
}

class _CustomDaySliderState extends State<CustomDaySlider> {
  int selectedDayIndex = 0;
  DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          childAspectRatio: 0.9,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
        ),
        itemCount: widget.totalDays,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          DateTime date = widget.from.add(Duration(days: index));

          if (index == selectedDayIndex) selectedDate = date;

          return CardDay(
            date: date,
            margin: EdgeInsets.all(4),
            isActive: (selectedDate.compareTo(date) == 0),
            onPressed: (DateTime d) {
              selectedDayIndex = index;
              setState(() {});
              widget.onDayPicked(d);
            },
          );
        },
      ),
    );
  }
}
