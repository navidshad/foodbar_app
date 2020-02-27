import 'package:flutter/material.dart';

import 'package:foodbar_user/widgets/widgets.dart';
import 'package:foodbar_flutter_core/models/models.dart';

class CustomDatePicker extends StatefulWidget {
  CustomDatePicker(
      {Key key,
      @required this.dateTitle,
      @required this.timeTitle,
      @required this.from,
      @required this.periods,
      this.totalDays = 7,
      this.reservedTimes = const [],
      @required this.onPickedDate,
      @required this.onPickedTime,
      })
      : super(key: key);

  final String dateTitle;
  final String timeTitle;
  final DateTime from;
  final int totalDays;
  final List<Period> periods;
  final List<DateTime> reservedTimes;
  final Function(DateTime picked) onPickedDate;
  final Function(DateTime picked) onPickedTime;

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
          widget.onPickedDate(value);
          widget.onPickedTime(null);
        });
      },
    );

    bodyColumnWidgets.add(dayPicker);

    // time picker ----------
    Widget timeSlider = CustomTimeSlider(
      key: Key(selected.toIso8601String()),
      title: widget.timeTitle,
      date: selected,
      periods: widget.periods,
      reservedTimes: widget.reservedTimes,
      onDayPicked: (DateTime value) {
        widget.onPickedTime(value);
      },
    );

    bodyColumnWidgets.add(timeSlider);

    return Column(
      children: bodyColumnWidgets,
    );
  }
}
