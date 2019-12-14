import 'package:flutter/material.dart';

import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/widgets/widgets.dart';

class MenuTabOnePageView extends StatelessWidget {

  final List<CategoryWithFoods> list;

  MenuTabOnePageView(this.list);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      padding: EdgeInsets.all(10),
      itemBuilder: (itemContext, int i) {
        CategoryWithFoods detail = list[i];
        return CategoryWithFoodsCard(detail);
      },
    );
  }
}
