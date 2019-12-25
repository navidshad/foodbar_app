import 'package:flutter/material.dart';

import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/utilities/text_util.dart';
import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/settings/app_properties.dart';
import 'package:Food_Bar/widgets/widgets.dart';

class OrderedFoodCard extends StatelessWidget {
  final Food food;
  CartBloc bloc;

  OrderedFoodCard(this.food);

  @override
  Widget build(BuildContext context) {
    bloc = AppFrameBlocProvider.of<CartBloc>(context);

    return LayoutBuilder(
      builder: (con, constraints) {
        // divide the maxScreenSize into 2/4 & 1/4 vars
        // widget elements will use these size
        double textblocmargin = 8;
        double one3th = constraints.biggest.width / 3.5;
        double two4th = constraints.biggest.width / 2;
        double one4th = constraints.biggest.width / 4 - textblocmargin;

        Widget widget = Container(
          //padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // thumbnial
              Container(
                width: one3th,
                height: one3th,
                child: Image.asset(
                  food.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),

              // title, counte
              Container(
                width: one3th,
                padding: EdgeInsets.only(
                    left: textblocmargin, right: textblocmargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        TextUtil.toUperCaseForLable(food.title),
                        textScaleFactor: 1,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    OrderCounterForOneFood(
                      count: 1,
                    )
                  ],
                ),
              ),

              // price
              Container(
                width: one4th,
                child: Center(
                  child: FittedBox(
                    child: Text(
                      '\$25',
                      style: TextStyle(color: AppProperties.mainColor),
                    ),
                  ),
                ),
              )
            ],
          ),
        );

        //return widget;
        return Card(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: widget,
          ),
          elevation: 20,
        );
      },
    );
  }

  void removeFromCart() {
    bloc.eventSink.add(CartEvent(remove:food));
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
  // }s
}
