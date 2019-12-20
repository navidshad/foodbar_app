import 'package:flutter/material.dart';

import 'package:Food_Bar/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/settings/app_properties.dart';

class CartTab extends StatefulWidget {
  @override
  _CartTabState createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  CartBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<CartBloc>(context);

    return BlocBuilder(
      bloc: bloc,
      condition: (oldState, newState) => (newState == ShowCartState),
      builder: (blocContext, CartState state) {
        List<Widget> widgets = [];

        ShowCartState stateDetail = state;

        stateDetail.cart.foods.forEach((food) {
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
    //bloc.close();
    super.dispose();
  }
}
