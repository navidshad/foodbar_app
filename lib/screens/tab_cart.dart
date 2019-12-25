import 'package:flutter/material.dart';

import 'package:Food_Bar/custom_bloc/bloc.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/settings/app_properties.dart';

class CartTab extends StatefulWidget {
  @override
  _CartTabState createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  CartBloc bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = AppFrameBlocProvider.of<CartBloc>(context);
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder (
      stream: bloc.stateStream,
      initialData: bloc.getInitialState(),
      builder: (streamContext, AsyncSnapshot snapshot) {

        List<Widget> widgets = [];
        CartState state = snapshot.data;

        state.cart.foods.forEach((food) {
          widgets.add(OrderedFoodCard(food));
        });

        return ListView(
          children: widgets,
          padding: EdgeInsets.all(AppProperties.cardSideMargin),
        );

      },
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
