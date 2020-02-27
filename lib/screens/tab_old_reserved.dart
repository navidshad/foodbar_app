import 'package:flutter/material.dart';

import 'package:Foodbar_user/bloc/bloc.dart';
import 'package:Foodbar_user/widgets/widgets.dart';
import 'package:Foodbar_user/settings/app_properties.dart';
import 'package:Foodbar_user/models/models.dart';

class OldReserved extends StatefulWidget {
  @override
  _OldReservedState createState() => _OldReservedState();
}

class _OldReservedState extends State<OldReserved> {
  ReservedBloc bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<ReservedBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    bloc.eventSink.add(GetOldReservedTables());

    return StreamBuilder<ReservedState>(
      stream: bloc.stateStream,
      initialData: bloc.getInitialState(),
      builder: (streamContext, AsyncSnapshot snapshot) {
        ReservedState state = snapshot.data;

        return GestureDetector(
          child: ListView(
            padding: EdgeInsets.only(
              top: AppProperties.cardVerticalMargin,
              left: AppProperties.cardSideMargin,
              right: AppProperties.cardSideMargin,
            ),
            children: <Widget>[
              for (ReservedTable rTable in state.reservedList)
                CardReservedDetail(reservedTable: rTable)
            ],
          ),
          // onVerticalDragEnd: (dragEndDetail) {
          //   print('onVerticalDragEnd');
          // },
          // onPanEnd: (dragEndDetail) {
          //   print('onPanEnd');
          // },
        );
      },
    );
  }
}
