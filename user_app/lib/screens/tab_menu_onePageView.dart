import 'package:flutter/material.dart';

import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_user/widgets/widgets.dart';

class MenuTabOnePageView extends StatelessWidget {

  final List<CategoryWithFoods> list;

  MenuTabOnePageView(this.list);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      //padding: EdgeInsets.all(10),
      itemBuilder: (itemContext, int i) {
        CategoryWithFoods detail = list[i];
        return CategoryWithFoodsCard(detail);
      },
    );
  }
}
