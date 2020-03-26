import 'package:flutter/material.dart';

import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_user/widgets/widgets.dart';
import 'package:foodbar_user/bloc/bloc.dart';
import 'package:foodbar_user/settings/app_properties.dart';

class SingleFood extends StatelessWidget {
  CartBloc bloc;

  Food food;
  int total = 1;

  double elevation = 0;
  double cardPadding = 20;

  @override
  Widget build(BuildContext context) {
    food = ModalRoute.of(context).settings.arguments;
    bloc = BlocProvider.of<CartBloc>(context);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (headerContext, bool innerBoxIsScrolled) {
          return <Widget>[
            CustomSilverappBar(
              title: food.title,
              heroTag: food.getCombinedTag(),
              backGroundImage: food.image.getUrl(),
            )
          ];
        },
        body: ListView(
          padding: EdgeInsets.all(AppProperties.cardSideMargin),
          children: <Widget>[
            // description
            Card(
              elevation: elevation,
              child: Container(
                padding: EdgeInsets.all(cardPadding),
                child: Text(food.description),
              ),
            ),

            // amount options
            Card(
              elevation: elevation,
              child: Container(
                padding: EdgeInsets.all(cardPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OrderCounterForOneFood(
                      title: 'Quantity',
                      count: total,
                      onChange: (value) {
                        total = value;
                      },
                    )
                  ],
                ),
              ),
            ),

            // order single food
            CardButton(
              elevation: elevation,
              title: 'Order Now',
              height: 50,
              //onTap: (){},
              margin: EdgeInsets.only(bottom: 15),
            ),

            // add to cart
            CardButton(
              elevation: elevation,
              title: 'Add To Cart',
              height: 50,
              isOutline: true,
              onTap: addToCart,
            )
          ],
        ),
      ),
    );
  }

  void addToCart() {
    var event = CartEvent(add: OrderedFood.fromFood(food, total: total));
    bloc.eventSink.add(event);
  }
}
