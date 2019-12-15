import 'package:Food_Bar/settings/app_properties.dart';
import 'package:flutter/material.dart';

import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/utilities/text_util.dart';

class FoodCard extends StatelessWidget {
  final Food food;

  FoodCard(this.food);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (con, constraints) {
        // divide the maxScreenSize into 2/4 & 1/4 vars
        // widget elements will use these size
        double two4th = constraints.biggest.width / 2;
        double one5th = constraints.biggest.width / 5;

        Widget widget = Container(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // thumbnial
              Container(
                width: one5th,
                height: one5th,
                child: Image.asset(
                  food.imageUrl,
                  height: 70,
                ),
              ),

              // title, description and price
              Container(
                width: two4th,
                margin: EdgeInsets.only(left: 8, right: 8),
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
                child: Column(
                  children: <Widget>[
                    OutlineButton(
                      child: Text('+ADD',
                          textScaleFactor: 0.8,
                          style: TextStyle(
                            color: AppProperties.mainColor,
                            fontWeight: FontWeight.bold)),
                      onPressed: () {},
                    ),
                  ],
                ),
              )
            ],
          ),
        );

        return widget;
      },
    );
  }
}
