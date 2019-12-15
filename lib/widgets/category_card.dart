import 'package:flutter/material.dart';

import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/utilities/text_util.dart';

class CategoryCard extends StatelessWidget {

  final Category category;

  CategoryCard(this.category);

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (layoutContext, constraints) {

        double one3 = constraints.biggest.width /3;
        double two3 = constraints.biggest.width /3*2;

        Widget cardBody = Row(
          children: <Widget>[
            
            // thumbnail
            Container(
              width: one3,
              height: one3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset(category.imageUrl).image,
                )
              ),
            ),

            // title & description
            Container(
              width: two3,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    TextUtil.toUperCaseForLable(category.title),
                    textScaleFactor: 1.4,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    TextUtil.toCapital(category.description),
                    textScaleFactor: 0.9,
                  ),
                ],
              ),
            ),

          ],
        );

        return Card(
          child: cardBody,
          margin: EdgeInsets.only(bottom: 15),
          elevation: 100,
          // shape: RoundedRectangleBorder(
          //   side: BorderSide(color: Colors.grey[300], width: 0.5, )
          // ),
        );

      },
    );
  }
}
