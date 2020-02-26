import 'package:flutter/material.dart';

import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/settings/app_properties.dart';

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
