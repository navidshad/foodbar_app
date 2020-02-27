import 'package:flutter/material.dart';

import 'package:Foodbar_user/widgets/widgets.dart';
import 'package:Foodbar_user/utilities/text_util.dart';

class CustomSilverappBar extends StatelessWidget {
  
  final String title;
  final String heroTag;
  final String backGroundImage;

  final Color iconColor = Colors.white;

  CustomSilverappBar({this.title, this.heroTag, this.backGroundImage});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        expandedHeight: 300,
        pinned: true,
        floating: true,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: iconColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          CartButton(color: iconColor,),
        ],
        actionsIconTheme: IconThemeData(size: 30),
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          titlePadding: EdgeInsets.only(left: 100, right: 100, bottom: 20),
          title: Text(
            TextUtil.toUperCaseForLable(title),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          background: Hero(
            tag: heroTag,
            child: Image.asset(backGroundImage, fit: BoxFit.cover),
          ),
        ));
  }
}
