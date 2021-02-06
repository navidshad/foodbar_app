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

    return CardWithCover(
      coverWithbyPersent: 30,
      heroTag: category.getCombinedTag(),
      imageUrl: category.image.getUrl(),
      onCardTap: onCardTab,
      mainAxisAlignment: MainAxisAlignment.center,
      contentPadding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 15,
        right: 15
      ),
      detailwidgets: <Widget>[
        Text(
          TextUtil.toUperCaseForLable(category.title),
          style: TextStyle(
            fontSize: AppProperties.h3,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
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
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        )
      ],
    );
  }

  void onCardTab() {
    Navigator.pushNamed(_context, '/category', arguments: category);
  }
}
