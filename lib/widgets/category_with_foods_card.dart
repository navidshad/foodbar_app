import 'dart:ui' as prefix0;

import 'package:Foodbar_user/settings/settings.dart';
import 'package:flutter/material.dart';

import 'package:Foodbar_user/models/models.dart';
import 'package:Foodbar_user/widgets/widgets.dart';

class CategoryWithFoodsCard extends StatelessWidget {
  final CategoryWithFoods category;

  CategoryWithFoodsCard(this.category);

  @override
  Widget build(BuildContext context) {
    // define a colore for category lable
    Color color = (category.imageUrl != null) ? Colors.white : Colors.black;
    Image imageCat = Image.asset(category.imageUrl);

    List<Widget> wigitList = [
      // header
      Container(
          height: 100,
          decoration: BoxDecoration(
              // borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              image: DecorationImage(image: imageCat.image, fit: BoxFit.cover)),
          child: ClipRect(
            child: BackdropFilter(
                filter: prefix0.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Center(
                  child: Text(category.title.toUpperCase(),
                      textScaleFactor: 1.8,
                      style:
                          TextStyle(color: color, fontWeight: FontWeight.bold)),
                )),
          )),
    ];

    // card body
    // listing foods
    category.foods.forEach((food) {
      Widget foodCard = Container(
        child: FoodCard(food),
        padding: EdgeInsets.only(
            left: AppProperties.cardSideMargin,
            right: AppProperties.cardSideMargin),
      );

      wigitList.add(foodCard);
    });

    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      child: Column(
        children: wigitList,
      ),
    );
  }
}
