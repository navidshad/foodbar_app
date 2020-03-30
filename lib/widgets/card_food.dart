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
        // widget elements will use these size
        double coverWith = constraints.biggest.width / 3.5;
        double restWith = constraints.biggest.width - coverWith;
        double cardHeight = 160;

        var detailSection = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              TextUtil.toUperCaseForLable(food.title),
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: AppProperties.h4),
            ),
            Text(
              TextUtil.toCapital(TextUtil.makeShort(
                food.subTitle,
                AppProperties.subTitleLength,
              )),
              style: TextStyle(fontSize: AppProperties.h5),
            ),
            
            Container(
              margin: EdgeInsets.only(top:20),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Text(
                    '\$25',
                    style: TextStyle(
                        color: AppProperties.mainColor,
                        fontSize: AppProperties.h4),
                  ),
                ),
                OutlineButton(
                  child: Text(
                    '+ADD',
                    style: TextStyle(
                        color: AppProperties.mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: AppProperties.p),
                  ),
                  onPressed: addToCart,
                )
              ],
            ),
            )
          ],
        );

        Widget widget = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // thumbnial
            Hero(
              tag: food.getCombinedTag(),
              child: SquareCover(
                width: coverWith,
                height: cardHeight,
                boxFit: BoxFit.cover,
                url: food.image.getUrl(),
              ),
            ),

            Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              width: restWith,
              child: detailSection,
            ),
          ],
        );

        //return widget;
        return InkWell(
          onTap: onCardTab,
          child: Card(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(AppProperties.cardRadius)),
              child: Container(
                color: Colors.white,
                height: cardHeight,
                child: widget,
              ),
            ),
            color: Colors.transparent,
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
