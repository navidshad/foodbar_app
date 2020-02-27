import 'package:flutter/material.dart';

import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_user/settings/app_properties.dart';
import 'package:foodbar_user/bloc/bloc.dart';

class ProceedToCheckout extends StatelessWidget {
  final Function onProceedToCheckout;
  final Function onApplyCoupon;

  ProceedToCheckout(
      {@required this.onApplyCoupon, @required this.onProceedToCheckout});

  @override
  Widget build(BuildContext context) {
    final CartBloc bloc = BlocProvider.of<CartBloc>(context);

    return StreamBuilder(
      stream: bloc.stateStream,
      initialData: bloc.getInitialState(),
      builder: (context, snapshot) {
        CartState state = snapshot.data;
        return buildCard(state.cart);
      },
    );
  }

  Widget buildCard(Cart cart) {
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
                        Text('\$${cart.deliveryCharges}', style: bold)
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
                disabledColor: AppProperties.disabledColor,
                disabledTextColor: AppProperties.textOnDisabled,
                onPressed: (cart.total > 0) ? onProceedToCheckout : null,
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
