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

    return CardWithCover(
      coverWithbyPersent: 30,
      heroTag: food.getCombinedTag(),
      imageUrl: food.image.getUrl(),
      onCardTap: onCardTab,
      contentPadding: EdgeInsets.only(
        top: 0,
        bottom: 0,
        left: 10,
        right: 15,
      ),
      detailwidgets: <Widget>[
        Text(
          TextUtil.toUperCaseForLable(food.title),
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: AppProperties.h5),
        ),
        Text(
          TextUtil.toCapital(TextUtil.makeShort(
            food.subTitle,
            AppProperties.subTitleLength,
          )),
          style: TextStyle(fontSize: AppProperties.p),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Text(
                  '\$25',
                  style: TextStyle(
                      color: AppProperties.mainColor,
                      fontSize: AppProperties.h5),
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
  }

  void addToCart() {
    bloc.eventSink.add(CartEvent(add: OrderedFood.fromFood(food)));
  }

  void onCardTab() {
    Navigator.pushNamed(_context, '/food', arguments: food);
  }
}
