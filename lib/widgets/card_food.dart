import 'package:flutter/material.dart';

import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_flutter_core/utilities/text_util.dart';
import 'package:foodbar_user/bloc/bloc.dart';
import 'package:foodbar_user/settings/app_properties.dart';
import 'package:foodbar_user/widgets/widgets.dart';

class FoodCard extends StatelessWidget {
  final Food food;
  CartBloc bloc;

  BuildContext _context;

  FoodCard(this.food);

  @override
  Widget build(BuildContext context) {
    _context = context;
    bloc = BlocProvider.of<CartBloc>(context);

    return LayoutBuilder(
      builder: (con, constraints) {
        // divide the maxScreenSize into 2/4 & 1/4 vars
        // widget elements will use these size
        double textblocmargin = 8;
        double two4th = constraints.biggest.width / 2;
        double one4th = constraints.biggest.width / 4;
        double one5th = constraints.biggest.width / 5 - textblocmargin;

        var detailSection = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              TextUtil.toUperCaseForLable(food.title),
              //textScaleFactor: 1,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: AppProperties.h3),
            ),
            Text(
              TextUtil.toCapital(food.subTitle),
              //textScaleFactor: 0.7,
              style: TextStyle(fontSize: AppProperties.h4),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '\$25',
                  style: TextStyle(
                      color: AppProperties.mainColor,
                      fontSize: AppProperties.h4),
                ),
                OutlineButton(
                  child: Text(
                    '+ADD',
                    //textScaleFactor: 0.8,
                    style: TextStyle(
                      color: AppProperties.mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: AppProperties.h4
                    ),
                  ),
                  onPressed: addToCart,
                )
              ],
            )
          ],
        );

        Widget widget = Container(
          //padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // thumbnial
              Hero(
                tag: food.getCombinedTag(),
                child: SquareCover(
                  sideSize: one4th,
                  boxFit: BoxFit.cover,
                  url: food.image.getUrl(),
                ),
              ),

              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                width: one4th * 3 - textblocmargin,
                child: detailSection,
              ),
            ],
          ),
        );

        //return widget;
        return InkWell(
          onTap: onCardTab,
          child: Card(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: widget,
            ),
            margin: EdgeInsets.only(bottom: AppProperties.cardVerticalMargin),
            elevation: AppProperties.cardElevation,
          ),
        );
      },
    );
  }

  void addToCart() {
    bloc.eventSink.add(CartEvent(add: OrderedFood.fromFood(food)));
  }

  void onCardTab() {
    Navigator.pushNamed(_context, '/food', arguments: food);
  }

  // void showBottomSlider(BuildContext context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (con) {
  //         return Container(
  //           height: 200,
  //         );
  //       },
  //       backgroundColor: Colors.green,
  //       isScrollControlled: false
  //       );
  // }
}
