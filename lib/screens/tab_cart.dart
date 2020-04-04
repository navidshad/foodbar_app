import 'package:flutter/material.dart';
import 'package:foodbar_flutter_core/foodbar_flutter_core.dart';

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
  List<OrderedFood> orders = [];
  GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<CartBloc>(context);
  }

  void removeItem(int index) {
    _listKey.currentState.removeItem(
      index,
      (context, animation) {
        var order = orders[index];

        animation.addStatusListener((status) {
          if (status == AnimationStatus.dismissed) {
            orders.removeAt(index);
            bloc.eventSink.add(CartEvent(remove: order));
          }
        });

        return FadeTransition(
          opacity: animation,
          child: OrderedFoodCard(
            order,
            //onRemove: () => removeItem(index),
          ),
        );
      },
    );
  }

  Widget _itemBuilder(context, index, animation) {
    Widget item;

    if (index == orders.length) {
      item = ProceedToCheckout(
        onApplyCoupon: () {},
        onProceedToCheckout: () {},
      );
    } else {
      item = OrderedFoodCard(
        orders[index],
        onRemove: () => removeItem(index),
      );
    }

    return FadeTransition(
      opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
      child: item,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.stateStream,
      initialData: bloc.getInitialState(),
      builder: (streamContext, AsyncSnapshot snapshot) {
        //List<Widget> widgets = [];
        CartState state = snapshot.data;
        orders = state.cart.foods;

        // add foods
        // state.cart.foods.forEach((food) {
        //   widgets.add(OrderedFoodCard(food));
        // });

        // add Proceed card
        // ProceedToCheckout proceedCard = ;

        // widgets.add(proceedCard);

        // return ListView(
        //   children: widgets,
        //   padding: EdgeInsets.all(AppProperties.cardSideMargin),
        // );

        return AnimatedList(
          key: _listKey,
          initialItemCount: orders.length + 1,
          padding: EdgeInsets.all(AppProperties.cardSideMargin),
          itemBuilder: _itemBuilder,
        );
      },
    );
  }
}
