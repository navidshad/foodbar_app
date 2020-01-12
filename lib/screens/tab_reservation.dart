import 'package:flutter/material.dart';

import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/settings/app_properties.dart';

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
          dateTitle: 'Pick a date',
          timeTitle: 'Pick a time',
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

        //total person picker ------
        Widget totalPersonPicker = CustomIntSlider(
          title: 'Number of persons',
          divisions: 15,
          min: 1,
          max: 15,
          onChanged: (int value) {},
        );

        bodyColumnWidgets.add(totalPersonPicker);

        // submite button
        Widget submite = Center(
          child: Container(
            width: 150,
            child: OutlineButton(
              child: Text('Reserve'),
              color: AppProperties.mainColor,
              onPressed: () {},
            ),
          ),
        );

        bodyColumnWidgets.add(submite);

        // combine all
        return ListView(children: bodyColumnWidgets);
      },
    );
  }
}
