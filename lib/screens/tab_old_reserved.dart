import 'dart:async';

import 'package:flutter/material.dart';

import 'package:foodbar_user/bloc/bloc.dart';
import 'package:foodbar_user/settings/settings.dart';
import 'package:foodbar_user/widgets/widgets.dart';
import 'package:foodbar_user/settings/app_properties.dart';
import 'package:foodbar_flutter_core/models/models.dart';

class OldReserved extends StatefulWidget {
  @override
  _OldReservedState createState() => _OldReservedState();
}

class _OldReservedState extends State<OldReserved> {
  ReservedBloc bloc;
  AppFrameBloc frameBloc;
  List<ReservedTable> reservedList = [];
  StreamController _removeItemController;
  StreamController _insertItemController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    frameBloc = BlocProvider.of<AppFrameBloc>(context);

    frameBloc.stateStream.listen((state) {
      if (state.type == FrameTabType.RESERVED)
        bloc.eventSink.add(GetOldReservedTables());
    });

    bloc = BlocProvider.of<ReservedBloc>(context);

    bloc.stateStream.listen((state) {
      reservedList = state.reservedList;
      if (this.mounted) setState(() {});
    });
  }

  void onCancel(int i) {
    var rTable = reservedList[i];

    _removeItemController.add(
      RemovedItem(
        index: i,
        widget: Padding(
          padding: EdgeInsets.only(
            top: AppProperties.cardVerticalMargin,
            left: AppProperties.cardSideMargin,
            right: AppProperties.cardSideMargin,
          ),
          child: CardReservedDetail(reservedTable: rTable),
        ),
      ),
    );

    reservedList.removeAt(i);

    var event = CancelReservedTable(
      rTable.id,
      onDone: (isSuccess, body) {
        if (isSuccess) {
        } else {
          reservedList.insert(i, rTable);
          _insertItemController.add(i);
        }
      },
    );

    bloc.eventSink.add(event);
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (reservedList.length == 0) {
      body = Center(
        child: Text(
          'There isn\'t reserved table, yet.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      _removeItemController = StreamController<RemovedItem>();
      _insertItemController = StreamController<int>();
      EdgeInsets padding = EdgeInsets.only(
        top: AppProperties.cardVerticalMargin,
        left: AppProperties.cardSideMargin,
        right: AppProperties.cardSideMargin,
      );

      body = CustomanimatedList(
        initialItemCount: reservedList.length,
        removeStream: _removeItemController.stream,
        inserStream: _insertItemController.stream,
        itemBuilder: (context, i) {
          var rTable = reservedList[i];
          return Padding(
            padding: padding,
            child: CardReservedDetail(
              reservedTable: rTable,
              onCancel: () => onCancel(i),
            ),
          );
        },
      );
    }

    return body;
  }
}
