
import 'package:flutter/material.dart';

import 'package:Food_Bar/bloc/bloc.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/settings/app_properties.dart';

class OldReserved extends StatefulWidget {
  @override
  _OldReservedState createState() => _OldReservedState();
}

class _OldReservedState extends State<OldReserved> {
  CartBloc bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<CartBloc>(context);
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder (
      stream: bloc.stateStream,
      initialData: bloc.getInitialState(),
      builder: (streamContext, AsyncSnapshot snapshot) {

        var state = snapshot.data;
        return Center(
          child: Text('Old Reserved')
        );
      },
    );
  }
}
