import 'package:foodbar_flutter_core/models/time.dart';
import 'package:flutter/material.dart';

import 'package:foodbar_user/widgets/widgets.dart';
import 'package:foodbar_user/settings/app_properties.dart';

class CustomTimeSlider extends StatefulWidget {
  CustomTimeSlider({
    Key key,
    @required this.title,
    @required this.periods,
    @required this.date,
    @required this.onDayPicked,
    this.reservedTimes = const [],
  }) : super(key: key);

  final String title;
  final List<Period> periods;
  final DateTime date;
  final List<DateTime> reservedTimes;

  final Function(DateTime day) onDayPicked;

  @override
  _CustomTimeSliderState createState() => _CustomTimeSliderState();
}

class _CustomTimeSliderState extends State<CustomTimeSlider> {
  int selectedDayIndex = 0;
  int totalCards = 0;
  DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        List<Widget> bodyColumnWidgets = [];

        // create Times -----------
        double cardMargin = 4;
        List<CardTime> cardTimes = [];

        // create cards
        for (int i = 0; i < widget.periods.length; i++) {
          Period period = widget.periods[i];
          totalCards = 0;

          period.getDividedTimes(widget.date).forEach((speratedTime) {
            totalCards++;
            int currentCard = totalCards;

            if (currentCard == selectedDayIndex) selectedDate = speratedTime;

            var card = CardTime(
              date: speratedTime,
              margin: EdgeInsets.all(cardMargin),
              backgroundColor: AppProperties.secondColor,
              textColor: AppProperties.textOnMainColor,
              disableColor: AppProperties.disabledColor,
              disableTextColor: AppProperties.textOnDisabled,
              isActive: (selectedDayIndex == currentCard),
              isReserved: isReserved(speratedTime),
              onPressed: (DateTime d) {
                selectedDayIndex = currentCard;
                setState(() {});
                widget.onDayPicked(d);
              },
            );

            cardTimes.add(card);
          });
        }

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
            ],
          ),
        );

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
              children: cardTimes,
            ),
          ),
        );

        bodyColumnWidgets.add(daysSectionWidget);

        return Column(children: bodyColumnWidgets);
      },
    );
  }

  bool isReserved(DateTime time) {
    bool key = false;

    widget.reservedTimes.forEach((t) {
      if(t.compareTo(time) == 0) key = true;
    });

    return key;
  }
}
