import 'package:Food_Bar/widgets/table_type_slider.dart';
import 'package:flutter/material.dart';

import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/settings/app_properties.dart';

class ReservationTab extends StatefulWidget {
  ReservationTab({Key key}) : super(key: key);

  @override
  _ReservationTabState createState() => _ReservationTabState();
}

class _ReservationTabState extends State<ReservationTab> {
  ReservationBloc bloc;
  int selectedPerson = 0;
  CustomTable selectedTable;
  DateTime selectedDate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<ReservationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        List<Widget> bodyColumnWidgets = [];

        // table picker ----
        Widget tablePicker = StreamBuilder<List<CustomTable>>(
          stream: bloc.tableStream,
          initialData: null,
          builder: buildTablePicker,
        );

        bodyColumnWidgets.add(tablePicker);

        // date picker -----
        Widget datePicker = StreamBuilder<ReservationState>(
          stream: bloc.stateStream,
          initialData: bloc.getInitialState(),
          builder: buildDatePicker,
        );
        bodyColumnWidgets.add(datePicker);

        //total person picker ------
        Widget totalPersonPicker = StreamBuilder<PersonPickerOptions>(
          stream: bloc.personStream,
          initialData: bloc.getPersonPickerIntialState(),
          builder: buildPersonPicker,
        );

        if (selectedDate != null) bodyColumnWidgets.add(totalPersonPicker);

        // submite button
        Widget submite = Center(
          child: Container(
            width: 150,
            child: OutlineButton(
              child: Text('Reserve'),
              color: AppProperties.mainColor,
              onPressed: (selectedPerson == 0) ? null : onConfirm,
            ),
          ),
        );

        bodyColumnWidgets.add(submite);

        // combine all
        return ListView(children: bodyColumnWidgets);
      },
    );
  }

  void onConfirm() {}

  Widget buildTablePicker(context, AsyncSnapshot<List<CustomTable>> snapshot) {
    List<CustomTable> tables = snapshot.data;
    Widget tablePicker;

    if (tables == null) {
      tablePicker = buildCircularProgressBar();
      getTables();
    } else {
      tablePicker = TableSlider(
        tables: tables,
        onPicked: (CustomTable table) {
          selectedTable = table;
          getTotalPerson();
        },
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 15),
      child: tablePicker,
    );
  }

  Widget buildPersonPicker(context, snapshot) {
    PersonPickerOptions options = snapshot.data;
    Widget personPicker;

    if (options.max == 0)
      personPicker = buildCircularProgressBar();
    else {
      personPicker = CustomIntSlider(
        title: 'Number of persons',
        divisions: options.divisions,
        min: options.min,
        max: options.max,
        onChanged: (int value) => setState(() {
          selectedPerson = value;
        }),
      );
    }

    return personPicker;
  }

  Widget buildDatePicker(
      context, AsyncSnapshot<ReservationState> optionsSnapshot) {
    ReservationState state = optionsSnapshot.data;
    Widget datePickerWidget;

    if (state.options == null) {
      datePickerWidget = buildCircularProgressBar();
      getShceduleOptions();
    } else {
      datePickerWidget = StreamBuilder<List<DateTime>>(
        stream: bloc.reservedTimeStream,
        initialData: [],
        builder: (context, timesSnapShot) {
          return CustomDatePicker(
            dateTitle: 'Pick a date',
            timeTitle: 'Pick a time',
            from: state.options.from,
            totalDays: state.options.totalDays,
            periods: state.options.periods,
            reservedTimes: timesSnapShot.data,
            onPickedDate: (picked) {
              getReservedTimes(picked);
            },
            onPickedTime: (picked) {
              setState(() {
                selectedDate = picked;
                getTotalPerson();
              });
            },
          );
        },
      );
    }

    return datePickerWidget;
  }

  Widget buildCircularProgressBar() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void getShceduleOptions() {
    bloc.eventSink.add(GetScheduleOptions());
  }

  void getTables() {
    bloc.eventSink.add(GetTables());
  }

  void getReservedTimes(DateTime day) {
    bloc.eventSink.add(GetReservedTimes(day));
  }

  void getTotalPerson() {
    if (selectedTable == null || selectedDate == null) return;

    bloc.eventSink.add(GetTotalPerson(
      date: selectedDate,
      table: selectedTable,
    ));
  }
}
