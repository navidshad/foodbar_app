import 'package:flutter/material.dart';

import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_flutter_core/utilities/text_util.dart';
import 'package:foodbar_user/bloc/bloc.dart';
import 'package:foodbar_user/services/services.dart';
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

    String currency = OptionsService.instance.properties.currency;
    String price = currency + food.price.toString();

    return CardWithCover(
      coverWithbyPersent: 30,
      heroTag: food.getCombinedTag(),
      imageUrl: food.image.getUrl(),
      onCardTap: onCardTab,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      contentPadding: EdgeInsets.only(
        left: 15,
      ),
      detailwidgets: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 15, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                TextUtil.toUperCaseForLable(food.title),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppProperties.h3,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                TextUtil.toCapital(TextUtil.makeShort(
                  food.subTitle,
                  AppProperties.subTitleLength,
                )),
                style: TextStyle(
                  fontSize: AppProperties.p,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20, bottom: 0),
                child: Text(
                  price,
                  style: TextStyle(
                    fontSize: AppProperties.h3,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppProperties.cardRadius)
                ),
                child: Material(
                  color: Theme.of(context).primaryColor,
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: 25,
                        right: 25,
                      ),
                      child: Text(
                        'Add To Cart',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: AppProperties.p),
                      ),
                    ),
                    onTap: addToCart,
                  ),
                ),
              ),
            ],
          ),
        ),
        //Text('fsdf')
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
