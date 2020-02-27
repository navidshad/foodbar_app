import 'package:flutter/material.dart';

import 'package:foodbar_user/bloc/bloc.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbar_user/widgets/widgets.dart';
import 'package:foodbar_user/settings/app_properties.dart';

class CartTab extends StatefulWidget {
  @override
  _CartTabState createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
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

        List<Widget> widgets = [];
        CartState state = snapshot.data;

        // add foods
        state.cart.foods.forEach((food) {
          widgets.add(OrderedFoodCard(food));
        });

        // add Proceed card
        ProceedToCheckout proceedCard = ProceedToCheckout(
          onApplyCoupon: () {},
          onProceedToCheckout: (){},
        );

        widgets.add(proceedCard);

        return ListView(
          children: widgets,
          padding: EdgeInsets.all(AppProperties.cardSideMargin),
        );

      },
    );
  }
}
