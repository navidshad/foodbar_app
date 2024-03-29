import 'package:foodbar_flutter_core/models/time.dart';
import 'package:flutter/material.dart';
import 'package:foodbar_flutter_core/utilities/date_util.dart';

import 'package:foodbar_user/widgets/widgets.dart';
import 'package:foodbar_user/settings/app_properties.dart';

class CustomTimeSlider extends StatefulWidget {
  CustomTimeSlider({
    Key? key,
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
        DateTime nowUTC = DateTime.utc(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          DateTime.now().hour,
          DateTime.now().minute,
          DateTime.now().second
        );

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

            bool isReserved = getReservationStatus(speratedTime);
            bool isPassed = nowUTC.isAfter(speratedTime);

            var card = CardTime(
              date: speratedTime,
              margin: EdgeInsets.all(cardMargin),
              isActive: (selectedDayIndex == currentCard),
              isReserved: isReserved,
              onPressed: (DateTime d) {
                selectedDayIndex = currentCard;
                setState(() {});
                widget.onDayPicked(d);
              },
            );

            if (!isReserved && !isPassed) cardTimes.add(card);
          });
        }

        Widget selectedDayLable = Container(
          margin: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              Text(
                DateUtil.getOnlyDate(widget.date),
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              )
            ],
          ),
        );

        bodyColumnWidgets.add(selectedDayLable);

        SingleChildScrollView daysSectionWidget = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 10, right: 10),
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

        if (widget.reservedTimes == null) {
          bodyColumnWidgets.add(Center(
            child: CircularProgressIndicator(),
          ));
        } else
          bodyColumnWidgets.add(daysSectionWidget);

        return Column(children: bodyColumnWidgets);
      },
    );
  }

  bool getReservationStatus(DateTime time) {
    bool key = false;

    List<DateTime> times = widget.reservedTimes ?? [];

    times.forEach((t) {
      if (t.compareTo(time) == 0) key = true;
    });

    return key;
  }
}
