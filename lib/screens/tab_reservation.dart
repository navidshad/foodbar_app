import 'package:foodbar_user/settings/settings.dart';
import 'package:foodbar_user/widgets/table_type_slider.dart';
import 'package:flutter/material.dart';

import 'package:foodbar_user/bloc/bloc.dart';
import 'package:foodbar_user/models/models.dart';
import 'package:foodbar_user/widgets/widgets.dart';
import 'package:foodbar_user/settings/app_properties.dart';

class ReservationTab extends StatefulWidget {
  ReservationTab({Key key}) : super(key: key);

  @override
  _ReservationTabState createState() => _ReservationTabState();
}

class _ReservationTabState extends State<ReservationTab> {
  ReservationBloc bloc;
  int selectedPersons = 0;
  CustomTable selectedTable;
  DateTime selectedDate;
  Key personSliderKey;
  List<DateTime> reservedTimes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<ReservationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ReservationState>(
      stream: bloc.stateStream,
      initialData: bloc.getInitialState(),
      builder: (context, stateSnapShot) {
        ReservationState state = stateSnapShot.data;
        Widget page;

        if (state is ConfirmState)
          page = buildConfirmationState(state);
        else
          page = buildScheduleState(state);

        return page;
      },
    );
  }

  Widget buildConfirmationState(ConfirmState confirmState) {
    Widget stateWidget;

    if (confirmState.waitingForResult) {
      stateWidget = Center(
        child: CircularProgressIndicator(),
      );
    } else {
      //stateWidget = Text('Thank You');
      stateWidget = ListView(
        children: <Widget>[
          ConfirmStateViewer(
            isSucceed: confirmState?.result?.succeed,
            subtitle: confirmState?.result?.message,
            processID: confirmState?.result?.reservationId,
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: CardButton(
              title: 'Reserve a New Table',
              height: 50,
              onTap: () => getShceduleOptions(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: CardButton(
              title: 'Back To Menu',
              height: 50,
              isOutline: true,
              onTap: () {
                AppFrameBloc menuBloc = BlocProvider.of<AppFrameBloc>(context);
                menuBloc.eventSink.add(AppFrameEvent(
                  //switchFrom: FrameTabType.Reserve,
                  switchTo: FrameTabType.MENU,
                ));
              },
            ),
          )
        ],
      );
    }

    return stateWidget;
  }

  Widget buildScheduleState(ScheduleState scheduleState) {
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
        Widget datePicker = buildDatePicker(scheduleState);
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
              onPressed: (selectedPersons == 0) ? null : onConfirm,
            ),
          ),
        );

        bodyColumnWidgets.add(submite);

        // combine all
        return ListView(children: bodyColumnWidgets);
      },
    );
  }

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

    if (options == null)
      personPicker = buildCircularProgressBar();
    else if (!(options.divisions == null || options.divisions > 0))
      personPicker = Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        // child: Text(
        //   'This Time Was Reserved',
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     color: Colors.red
        //   ),
        // ),
      );
    else {
      // this is a phase for halde the key of slider
      // the key must hadle in a custome way.
      // becuase when this (selectedPersons > options.max) will be happened
      // slider must be reseted.
      if (personSliderKey == null)
        personSliderKey = Key(options.hashCode.toString());
      if (selectedPersons > options.max) {
        personSliderKey = Key(options.hashCode.toString());
        selectedPersons = options.max.toInt();
      }

      personPicker = CustomIntSlider(
        title: 'Number of persons',
        key: personSliderKey,
        divisions: options.divisions ?? 0,
        min: options.min,
        max: options.max,
        onChanged: (int value) => setState(() {
          selectedPersons = value;
        }),
      );
    }

    return personPicker;
  }

  Widget buildDatePicker(ScheduleState state) {
    Widget datePickerWidget;

    if (state.options == null) {
      datePickerWidget = buildCircularProgressBar();
      getShceduleOptions();
    } else {
      // schedule option contains reservedTimes
      // add it
      if (state.options.reservedTimes.length > 0)
        reservedTimes = state.options.reservedTimes;

      datePickerWidget = StreamBuilder<List<DateTime>>(
        stream: bloc.reservedTimeStream,
        initialData: reservedTimes,
        builder: (context, timesSnapShot) {
          if (reservedTimes == null) getReservedTimes(state.options.from);

          reservedTimes = timesSnapShot.data;

          return CustomDatePicker(
            dateTitle: 'Pick a date',
            timeTitle: 'Pick a time',
            from: state.options.from,
            totalDays: state.options.totalDays,
            periods: state.options.periods,
            reservedTimes: reservedTimes ?? [],
            onPickedDate: (picked) {
              setState(() {
                getReservedTimes(picked);
              });
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
    bloc.eventSink.add(GetReservedTimes(day, selectedTable?.id));
  }

  void getTotalPerson() {
    if (selectedTable == null || selectedDate == null) return;

    bloc.eventSink.add(GetTotalPerson(
      date: selectedDate,
      table: selectedTable,
    ));
  }

  void onConfirm() {
    ReserveTable event = ReserveTable(
      date: selectedDate,
      persons: selectedPersons,
      table: selectedTable,
    );

    setState(() {
      selectedDate = null;
      selectedPersons = 0;

      bloc.eventSink.add(event);
    });
  }
}
