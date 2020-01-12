import 'package:flutter/material.dart';

import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/models/models.dart';

class CustomDatePicker extends StatefulWidget {
  CustomDatePicker(
      {Key key,
      @required this.dateTitle,
      @required this.timeTitle,
      this.from,
      this.totalDays,
      this.periods,
      this.onPickDate})
      : super(key: key);

  final String dateTitle;
  final String timeTitle;
  final DateTime from;
  final int totalDays;
  final List<Period> periods;
  final Function(DateTime picked) onPickDate;

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime selected;

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyColumnWidgets = [];

    // for the first time
    // because time slider need it
    selected = selected ?? widget.from;

    // day picker -----
    Widget dayPicker = CustomDaySlider(
      title: widget.dateTitle,
      from: widget.from,
      totalDays: widget.totalDays,
      onDayPicked: (DateTime value) {
        setState(() {
          selected = value;
        });
      },
    );

    bodyColumnWidgets.add(dayPicker);

    // time picker ----------
    Widget timeSlider = CustomTimeSlider(
      title: widget.timeTitle,
      date: selected,
      periods: widget.periods,
      onDayPicked: (DateTime value) {
        print(value.toIso8601String());
        widget.onPickDate(value);
      },
    );

    bodyColumnWidgets.add(timeSlider);

    return Column(
      children: bodyColumnWidgets,
    );
  }
}
