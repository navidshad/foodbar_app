class Time {
  int houre;
  int minutes;

  Time({this.houre = 0, this.minutes = 0});

  factory Time.fromMap(Map detail) {
    return Time(houre: detail['houre'], minutes: detail['minutes']);
  }
}

class Period {
  Time from;
  Time to;

  int dividedPerMinutes;

  Period({this.from, this.to, this.dividedPerMinutes = 30});

  factory Period.fromMap(Map detail) {
    return Period(
      from: Time.fromMap(detail['from']),
      to: Time.fromMap(detail['to']),
    );
  }

  List<DateTime> getDividedTimes(DateTime date) {
    DateTime dateStartTime = DateTime.utc(
      date.year,
      date.month,
      date.day,
      from.houre,
      from.minutes,
    );
    DateTime dateEndTime = DateTime.utc(
      date.year,
      date.month,
      date.day,
      to.houre,
      to.minutes,
    );

    List<DateTime> list = [];
    int counter = 0;

    bool keepDividingTime = true;

    while (keepDividingTime) {
      DateTime newTime =
          dateStartTime.add(Duration(minutes: dividedPerMinutes * counter));
      list.add(newTime);

      int compairedDates = dateEndTime.compareTo(newTime);
      if (compairedDates <= 0) keepDividingTime = false;

      counter++;
    }

    return list;
  }
}
