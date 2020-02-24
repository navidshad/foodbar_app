import 'package:flutter/material.dart';

import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/settings/app_properties.dart';

class OrdersTab extends StatefulWidget {
  @override
  _OrdersTabState createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  OrderBloc bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<OrderBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.stateStream,
      initialData: bloc.getInitialState(),
      builder: (streamContext, AsyncSnapshot snapshot) {
        OrderState state = snapshot.data;

        return GestureDetector(
          child: ListView(
            children: <Widget>[
              for (Order rTable in state.orderList)
                Text(rTable.date.toString())
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
