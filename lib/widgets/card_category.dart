import 'package:foodbar_user/settings/app_properties.dart';
import 'package:flutter/material.dart';

import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_flutter_core/utilities/text_util.dart';
import 'package:foodbar_user/widgets/widgets.dart';

class CardCategory extends StatelessWidget {
  final Category category;
  BuildContext _context;

  CardCategory(this.category);

  @override
  Widget build(BuildContext context) {
    _context = context;

    return LayoutBuilder(
      builder: (layoutContext, constraints) {
        double one3 = constraints.minWidth / 3;
        double rest = constraints.minWidth - one3;
        double cardHieght = 140;

        Widget cardBody = Row(
          children: <Widget>[
            // thumbnail
            Hero(
              tag: category.getCombinedTag(),
              child: SquareCover(
                boxFit: BoxFit.fitHeight,
                url: category.image.getUrl(),
                width: one3,
                height: cardHieght,
              ),
            ),

            // title & description
            Container(
              width: rest,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    TextUtil.toUperCaseForLable(category.title),
                    style: TextStyle(
                      fontSize: AppProperties.h3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Text(
                      TextUtil.toCapital(
                        TextUtil.makeShort(
                          category.description,
                          AppProperties.descriptionLength,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: AppProperties.p,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

        return InkWell(
          child: Card(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(AppProperties.cardRadius)),
              child: Container(
                child: cardBody,
                color: Colors.white,
                height: cardHieght,
              ),
            ),
            margin: EdgeInsets.only(bottom: AppProperties.cardVerticalMargin),
            elevation: AppProperties.cardElevation,
            color: Colors.transparent,
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
