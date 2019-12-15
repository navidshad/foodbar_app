import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';

import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/widgets/widgets.dart';

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
    int foodCounter = 0;
    category.foods.forEach((food) {
      if (foodCounter > 0) wigitList.add(Divider(height: 0,));
      wigitList.add(FoodCard(food));
      foodCounter++;
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
