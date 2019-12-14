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
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            image: DecorationImage(
                image: imageCat.image,
                fit: BoxFit.cover)),
        child: Center(
          child: Text(
            category.title.toUpperCase(), 
            textScaleFactor: 1.8,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold)),
        ),
      ),
    ];

    // card body
    // listing foods
    category.foods.forEach((food) {
      wigitList.add(Divider());
      wigitList.add(FoodCard(food));
    });

    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 50),
      child: Column(
        children: wigitList,
      ),
    );
  }
}
