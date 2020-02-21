import 'package:flutter/material.dart';

import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/settings/app_properties.dart';
import 'package:Food_Bar/utilities/date_util.dart';

class CustomDaySlider extends StatefulWidget {
  CustomDaySlider({
    Key key,
    @required this.title,
    this.totalDays,
    this.from,
    @required this.onDayPicked,
  }) : super(key: key);

  final String title;
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
    return LayoutBuilder(
      key: widget.key,
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
            isActive: (selectedDate.compareTo(date) == 0),
            onPressed: (DateTime d) {
              selectedDayIndex = i;
              setState(() {});
              widget.onDayPicked(d);
            },
          ));
        }

        // selected Day Lable -----
        Widget selectedDayLable = Container(
          margin: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.title,
                textScaleFactor: 1.5,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                DateUtil.getOnlyDate(selectedDate),
                style: TextStyle(color: AppProperties.secondColor),
              )
            ],
          ),
        );

        bodyColumnWidgets.add(selectedDayLable);

        SingleChildScrollView daysSectionWidget = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
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
