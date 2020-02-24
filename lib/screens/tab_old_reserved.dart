import 'package:flutter/material.dart';

import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/settings/app_properties.dart';
import 'package:Food_Bar/models/models.dart';

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
            children: <Widget>[
              for (ReservedTable rTable in state.reservedList)
                Text(rTable.from.toString())
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
