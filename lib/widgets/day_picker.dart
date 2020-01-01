import 'package:flutter/material.dart';

import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/settings/app_properties.dart';
import 'package:Food_Bar/utilities/date_util.dart';

class CustomDayPicker extends StatefulWidget {
  CustomDayPicker({Key key, this.totalDays, this.from, @required this.onDayPicked})
      : super(key: key);

  final totalDays;
  final DateTime from;
  final Function(DateTime day) onDayPicked;

  @override
  _CustomDayPickerState createState() => _CustomDayPickerState();
}

class _CustomDayPickerState extends State<CustomDayPicker> {
  int selectedDayIndex = 0;
  DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        List<Widget> bodyColumnWidgets = [];

        // create Days -----------
        double cardMargin = 4;
        List<CardDay> cardDays = [];

        for (int i = 0; i < widget.totalDays; i++) {
          DateTime date = widget.from.add(Duration(days: i));

          if (i == selectedDayIndex) selectedDate = date;

          cardDays.add(CardDay(
            date: date,
            margin: EdgeInsets.all(cardMargin),
            backgroundColor: AppProperties.secondColor,
            textColor: AppProperties.textOnMainColor,
            disableColor: AppProperties.disabledColor,
            disableTextColor: AppProperties.textOnDisabled,
            isActive: (selectedDayIndex == i),
            onPressed: (DateTime d) {
              selectedDayIndex = i;
              setState(() {});
              widget.onDayPicked(d);
            },
          ));
        }

        // selected Day Lable -----
        Container selectedDayLable = Container(
            width: constraints.maxWidth,
            padding: EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  DateUtil.longWeekDays[selectedDate.weekday],
                  textScaleFactor: 2,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  DateUtil.getOnlyDate(selectedDate),
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ));

        bodyColumnWidgets.add(selectedDayLable);

        SingleChildScrollView daysSectionWidget = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              //maxHeight: 100,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: cardDays,
            ),
          ),
        );

        bodyColumnWidgets.add(daysSectionWidget);

        return Column(children: bodyColumnWidgets);
      },
    );
  }
}
