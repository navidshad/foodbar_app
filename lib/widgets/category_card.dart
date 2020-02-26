import 'package:Food_Bar/settings/app_properties.dart';
import 'package:flutter/material.dart';

import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/utilities/text_util.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  BuildContext _context;

  CategoryCard(this.category);

  @override
  Widget build(BuildContext context) {
    _context = context;

    return LayoutBuilder(
      builder: (layoutContext, constraints) {
        double one3 = constraints.biggest.width / 3;
        double two3 = constraints.biggest.width / 3 * 2;

        Widget cardBody = Row(
          children: <Widget>[
            // thumbnail
            Hero(
              tag: category.getCombinedTag(),
              child: Container(
                width: one3,
                height: one3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset(category.imageUrl).image,
                )),
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

        return InkWell(
          child: Card(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: cardBody,
            ),
            margin: EdgeInsets.only(bottom: AppProperties.cardVerticalMargin),
            elevation: AppProperties.cardElevation,
          ),
          onTap: onCardTab,
        );
      },
    );
  }

  void onCardTab() {
    Navigator.pushNamed(_context, '/category', arguments: category);
  }
}
