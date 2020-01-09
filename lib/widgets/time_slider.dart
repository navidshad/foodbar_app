import 'package:Food_Bar/models/time.dart';
import 'package:flutter/material.dart';

import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/settings/app_properties.dart';

class CustomTimeSlider extends StatefulWidget {
  CustomTimeSlider(
      {Key key,
      @required this.periods,
      @required this.date,
      @required this.onDayPicked})
      : super(key: key);

  final List<Period> periods;
  final DateTime date;

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
              onPressed: (DateTime d) {
                selectedDayIndex = currentCard;
                setState(() {});
                widget.onDayPicked(d);
              },
            );

            cardTimes.add(card);
          });
        }

        //bodyColumnWidgets.add(selectedDayLable);

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
}
