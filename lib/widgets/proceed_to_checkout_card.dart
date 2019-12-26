import 'package:flutter/material.dart';

import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/settings/app_properties.dart';

class ProceedToCheckout extends StatelessWidget {
  final Cart cart;
  final Function onProceedToCheckout;
  final Function onApplyCoupon;

  ProceedToCheckout(
      {@required this.cart, @required this.onApplyCoupon, @required this.onProceedToCheckout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (con, constraints) {
        TextStyle bold = TextStyle(fontWeight: FontWeight.bold);

        Widget cartBody = Column(
          children: <Widget>[
            // items detail
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Item Total'),
                        Text('\$${cart.itemTotal}', style: bold)
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Delivery Charges'),
                        Text('\$${cart.deliveryChages}', style: bold)
                      ]),
                  Container(
                    height: 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Coupon Discount'),
                        FittedBox(
                          child: OutlineButton(
                            child: Text('+ADD',
                                textScaleFactor: 0.8,
                                style: TextStyle(
                                    color: AppProperties.mainColor,
                                    fontWeight: FontWeight.bold)),
                            onPressed: onApplyCoupon,
                          ),
                        )
                      ]),
                  Divider(
                    height: 40,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Total', textScaleFactor: 1.3, style: bold),
                        Text('\$${cart.total}',
                            textScaleFactor: 1.3,
                            style: TextStyle(
                                color: AppProperties.mainColor,
                                fontWeight: FontWeight.bold))
                      ]),
                ],
              ),
            ),

            Container(
              width: constraints.maxWidth,
              height: 50,
              child: FlatButton(
                shape: Border.all(width: 0, color: Colors.transparent),
                child: Text(
                  'Proceed to Checkout',
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: AppProperties.textOnMainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                color: AppProperties.mainColor,
                onPressed: onProceedToCheckout,
              ),
            )
          ],
        );

        return Card(
          elevation: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: cartBody,
          ),
        );
      },
    );
  }
}
