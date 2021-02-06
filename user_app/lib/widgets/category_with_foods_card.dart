import 'dart:ui' as prefix0;

import 'package:foodbar_user/settings/settings.dart';
import 'package:flutter/material.dart';

import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_user/widgets/widgets.dart';

class CategoryWithFoodsCard extends StatelessWidget {
  final CategoryWithFoods category;

  CategoryWithFoodsCard(this.category);

  @override
  Widget build(BuildContext context) {
    // define a colore for category lable
    Color color = (category.image.isAbsolute) ? Colors.white : Colors.black;
    Image imageCat = Image.network(category.image.getUrl());

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
