import 'package:flutter/material.dart';

import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_flutter_core/utilities/text_util.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  late BuildContext _context;

  double verticalMargin;
  double elevation;

  CategoryCard(
    this.category, {
    this.elevation = 20,
    this.verticalMargin = 15,
  });

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
                  image: Image.asset(category.image!.getUrl()).image,
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
            margin: EdgeInsets.only(bottom: verticalMargin),
            elevation: elevation,
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
