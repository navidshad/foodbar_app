import 'package:flutter/material.dart';

import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/utilities/text_util.dart';
import 'package:Food_Bar/settings/app_properties.dart';

class SingleFood extends StatelessWidget {
  CartBloc bloc;

  Food food;
  int count = 0;

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
            SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                floating: true,
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding:
                      EdgeInsets.only(left: 100, right: 100, bottom: 20),
                  title: Text(
                    TextUtil.toUperCaseForLable(food.title),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  background: Hero(
                    tag: food.getCombinedTag(),
                    child: Image.asset(food.imageUrl, fit: BoxFit.cover),
                  ),
                ))
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
                      count: count,
                      onChange: (value) { count = value; },
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
              onTap: (){},
              margin: EdgeInsets.only(bottom: 15),
            ),

            // add to cart
            CardButton(
              elevation: elevation,
              title: 'Add To Cart',
              height: 50,
              isOutline: true,
              onTap: (){},
            )
          ],
        ),
      ),
    );
  }
}
