import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/settings/settings.dart';
import 'package:Food_Bar/widgets/date_picker.dart';
import 'package:Food_Bar/widgets/time_slider.dart';
import 'package:flutter/material.dart';

import 'package:Food_Bar/widgets/widgets.dart';

class ReservationTab extends StatefulWidget {
  ReservationTab({Key key}) : super(key: key);

  @override
  _ReservationTabState createState() => _ReservationTabState();
}

class _ReservationTabState extends State<ReservationTab> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        List<Widget> bodyColumnWidgets = [];

        // date picker -----
        Widget dayPicker = CustomDatePicker(
          from: DateTime.now(),
          totalDays: 7,
          periods: [
            Period(
                from: Time(houre: 12),
                to: Time(houre: 21),
                dividedPerMinutes: 60)
          ],
          onPickDate: (picked) {},
        );
        bodyColumnWidgets.add(dayPicker);

        // combine all
        return ListView(children: bodyColumnWidgets);
      },
    );
  }
}
