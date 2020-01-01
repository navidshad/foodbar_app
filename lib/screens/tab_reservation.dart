import 'package:Food_Bar/settings/settings.dart';
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

        // day picker -----
        Widget dayPicker = CustomDayPicker(
          from: DateTime.now(),
          totalDays: 7,
          onDayPicked: (DateTime selected) {},
        );

        bodyColumnWidgets.add(dayPicker);

        // table section ----------

        return Column(children: bodyColumnWidgets);
      },
    );
  }
}
