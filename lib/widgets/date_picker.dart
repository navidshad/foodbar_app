import 'package:flutter/material.dart';
import 'package:foodbar_user/bloc/reservation_bloc.dart';

import 'package:foodbar_user/widgets/widgets.dart';
import 'package:foodbar_flutter_core/models/models.dart';

class CustomDatePicker extends StatefulWidget {
  CustomDatePicker({
    Key key,
    @required this.dateTitle,
    @required this.timeTitle,
    @required this.bloc,
    // @required this.onPickedDate,
    @required this.onPickedTime,
  }) : super(key: key);

  final String dateTitle;
  final String timeTitle;
  final ReservationBloc bloc;
  // final Function(DateTime picked) onPickedDate;
  final Function(DateTime picked) onPickedTime;

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime selected;
  ReservationScheduleOption options;
  List<DateTime> reservedTimes = [];

  @override
  void initState() {
    widget.bloc.stateStream.listen((state) {
      if (state is ScheduleState) {
        options = state.options;
        if(this.mounted) setState(() {});
      } else {}
    });

    widget.bloc.reservedTimeStream.listen((List<DateTime> list) {
      reservedTimes = list;
      
      // (list ?? <DateTime>[]).forEach((time) {
      //   print(time.toIso8601String());
      // });

      if(this.mounted) setState(() {});
    });

    super.initState();
  }

  void scheduleState() {
    widget.bloc.eventSink.add(GetScheduleOptions());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        List<Widget> bodyColumnWidgets = [];
        double totalHeight = constraints.maxHeight;

        if (options == null) {
          bodyColumnWidgets.add(Center(
            child: CircularProgressIndicator(),
          ));
          
          scheduleState();
        } else {
          // for the first time
          // because time slider needs it
          selected = selected ?? options.from;          

          // day picker -----
          Widget dayPicker = CustomDaySlider(
            title: widget.dateTitle,
            height: totalHeight / 100 * 60,
            from: options.from,
            totalDays: options.totalDays,
            onDayPicked: (DateTime value) {
              setState(() {
                selected = value;
                ReservationBloc.selectedDate = selected;
                widget.bloc.eventSink.add(GetReservedTimes());
                ReservationBloc.selectedTime = null;
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
            periods: options.periods,
            reservedTimes: reservedTimes,
            onDayPicked: (DateTime value) {
              ReservationBloc.selectedTime = value;
              widget.onPickedTime(value);
            },
          );

          bodyColumnWidgets.add(timeSlider);
        }

        return Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: bodyColumnWidgets,
          ),
        );
      },
    );
  }
}
