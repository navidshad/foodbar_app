import 'package:Food_Bar/widgets/cart_button.dart';
import 'package:flutter/material.dart';

import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/utilities/text_util.dart';
import 'package:Food_Bar/settings/app_properties.dart';

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
              backGroundImage: food.imageUrl,
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
