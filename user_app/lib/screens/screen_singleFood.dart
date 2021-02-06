import 'package:flutter/material.dart';

import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_user/services/options_service.dart';
import 'package:foodbar_user/settings/app_properties.dart';
import 'package:foodbar_user/widgets/widgets.dart';
import 'package:foodbar_user/bloc/bloc.dart';

class SingleFood extends StatefulWidget {
  @override
  _SingleFoodState createState() => _SingleFoodState();
}

class _SingleFoodState extends State<SingleFood> {
  CartBloc bloc;

  Food food;

  int total = 1;

  double elevation = 0;

  double cardPadding = 20;

  @override
  Widget build(BuildContext context) {
    food = ModalRoute.of(context).settings.arguments;
    bloc = BlocProvider.of<CartBloc>(context);

    String currency = OptionsService.instance.properties.currency;
    String price = currency + (total * food.price).toString();

    return Scaffold(
      body: PageWithScalableHeader(
        heroTag: food.getCombinedTag(),
        headerTitle: food.title,
        headerDescription: food.subTitle,
        headerColor: Colors.lightBlue,
        headerBackImageUrl: food.image.getUrl(),
        isFlexible: true,
        isHeaderExtendWhenPageOpened: true,
        headerHeight: 300,
        bodyColor: Theme.of(context).cardColor,
        actionButtons: <Widget>[
          CartButton(color: Colors.white),
        ],
        body: ListView(
          padding: EdgeInsets.only(left: 60, right: 60, top: 35, bottom: 10),
          children: <Widget>[
            // description
            Container(
              child: Text(
                food.description,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),

            SizedBox(height: 40),

            // amount options
            Container(
              //padding: EdgeInsets.all(cardPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  OrderCounterForOneFood(
                    //title: 'Quantity',
                    count: total,
                    onChange: (value) {
                      total = value;
                      setState(() {});
                    },
                  ),
                  Container(
                    child: Text(
                      price,
                      style: TextStyle(
                        fontSize: AppProperties.h2,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),

            // order single food
            CardButton(
              elevation: elevation,
              title: 'Order Now',
              height: 50,
              //onTap: (){},
              isOutline: true,
              margin: EdgeInsets.only(bottom: 15),
            ),

            // add to cart
            CardButton(
              elevation: elevation,
              title: 'Add To Cart',
              height: 50,
              isOutline: false,
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
