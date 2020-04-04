import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_flutter_core/utilities/text_util.dart';
import 'package:foodbar_user/bloc/bloc.dart';
import 'package:foodbar_user/services/services.dart';
import 'package:foodbar_user/settings/app_properties.dart';
import 'package:foodbar_user/utilities/food_bar_icons.dart';
import 'package:foodbar_user/widgets/widgets.dart';

class OrderedFoodCard extends StatelessWidget {
  OrderedFood food;
  CartBloc bloc;
  Function onRemove;

  OrderedFoodCard(this.food, {this.onRemove});

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<CartBloc>(context);

    String currency = OptionsService.instance.properties.currency;

    return CardWithCover(
      imageUrl: food.image.getUrl(),
      coverWithbyPersent: 30,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      contentPadding: EdgeInsets.only(
        left: 20,
        right: onRemove != null ? 0 : 20,
        top: onRemove != null ? 0 : 15,
        bottom: 5,
      ),
      detailwidgets: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              TextUtil.toUperCaseForLable(food.title),
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: AppProperties.h3,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (onRemove != null)
              ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppProperties.cardRadius)),
                child: Material(
                  color: Theme.of(context).errorColor,
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                        left: 10,
                        right: 10,
                      ),
                      child: Icon(
                        FontAwesomeIcons.minus,
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                    onTap: onRemove,
                  ),
                ),
              )
          ],
        ),
        Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
            )),
        Container(
          padding: EdgeInsets.only(
            right: onRemove != null ? 20 : 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // counte
              OrderCounterForOneFood(
                count: food.total,
                onChange: (value) {
                  food.total = value;
                  updateCart();
                },
              ),

              // price
              Container(
                // width: one4th,
                child: Center(
                  child: FittedBox(
                    child: Text(
                      currency + food.totalPrice.toString(),
                      style: TextStyle(
                        fontSize: AppProperties.h3,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  void removeFromCart() {
    bloc.eventSink.add(CartEvent(remove: food));
  }

  void updateCart() {
    var event = CartEvent(update: food);
    bloc.eventSink.add(event);
  }
}
