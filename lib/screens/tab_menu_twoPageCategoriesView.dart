import 'package:flutter/material.dart';

import 'package:Foodbar_user/models/models.dart';
import 'package:Foodbar_user/widgets/widgets.dart';
import 'package:Foodbar_user/settings/app_properties.dart';

class MenuTabTwoPageCategoriesView extends StatelessWidget {
  final List<Category> list;

  MenuTabTwoPageCategoriesView(this.list);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(AppProperties.cardSideMargin),
      itemCount: list.length,
      itemBuilder: (itemContext, int i) {
        Category detail = list[i];
        return CategoryCard(detail);
      },
    );
  }
}
