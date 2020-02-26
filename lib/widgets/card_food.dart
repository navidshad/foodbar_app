import 'package:flutter/material.dart';

import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/utilities/text_util.dart';
import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/settings/app_properties.dart';

class FoodCard extends StatelessWidget {
  final Food food;
  CartBloc bloc;

  BuildContext _context;

  FoodCard(this.food);

  @override
  Widget build(BuildContext context) {
    _context = context;
    bloc = BlocProvider.of<CartBloc>(context);

    return LayoutBuilder(
      builder: (con, constraints) {
        // divide the maxScreenSize into 2/4 & 1/4 vars
        // widget elements will use these size
        double textblocmargin = 8;
        double two4th = constraints.biggest.width / 2;
        double one4th = constraints.biggest.width / 4;
        double one5th = constraints.biggest.width / 5 - textblocmargin;

        Widget widget = Container(
          //padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // thumbnial
              Hero(
                tag: food.getCombinedTag(),
                child: Container(
                  width: one4th,
                  height: one4th,
                  child: Image.asset(
                    food.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // title, description and price
              Container(
                width: two4th,
                margin: EdgeInsets.all(textblocmargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      TextUtil.toUperCaseForLable(food.title),
                      textScaleFactor: 1,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      TextUtil.toCapital(food.description),
                      textScaleFactor: 0.7,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Text(
                        '\$25',
                        style: TextStyle(color: AppProperties.mainColor),
                      ),
                    )
                  ],
                ),
              ),

              // button & price
              Container(
                width: one5th,
                padding: EdgeInsets.only(right: 10),
                child: Column(
                  children: <Widget>[
                    FittedBox(
                      child: OutlineButton(
                        child: Text('+ADD',
                            textScaleFactor: 0.8,
                            style: TextStyle(
                                color: AppProperties.mainColor,
                                fontWeight: FontWeight.bold)),
                        onPressed: addToCart,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );

        //return widget;
        return InkWell(
          onTap: onCardTab,
          child: Card(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: widget,
            ),
            margin: EdgeInsets.only(bottom: AppProperties.cardVerticalMargin),
            elevation: AppProperties.cardElevation,
          ),
        );
      },
    );
  }

  void addToCart() {
    bloc.eventSink.add(CartEvent(add: OrderedFood.fromFood(food)));
  }

  void onCardTab() {
    Navigator.pushNamed(_context, '/food', arguments: food);
  }

  // void showBottomSlider(BuildContext context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (con) {
  //         return Container(
  //           height: 200,
  //         );
  //       },
  //       backgroundColor: Colors.green,
  //       isScrollControlled: false
  //       );
  // }
}
