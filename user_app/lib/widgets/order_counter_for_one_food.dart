import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodbar_user/settings/app_properties.dart';
import 'package:foodbar_user/widgets/circle_button.dart';

class OrderCounterForOneFood extends StatefulWidget {
  final int count;
  final Function(int newCount) onChange;
  final String title;
  final min;

  OrderCounterForOneFood({this.count, this.onChange, this.title, this.min = 1});

  @override
  _OrderCounterForOneFoodState createState() =>
      _OrderCounterForOneFoodState(count, onChange, title);
}

class _OrderCounterForOneFoodState extends State<OrderCounterForOneFood> {
  int counter;
  Function(int newCount) onChange;
  String title;

  _OrderCounterForOneFoodState(this.counter, this.onChange, this.title);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (layoutContext, boxConstraints) {
        double borderThikness = 0.2;
        double defaultWidth = 120;
        double width;

        if (boxConstraints.biggest.width > defaultWidth)
          width = defaultWidth;
        else
          width = boxConstraints.biggest.width;

        double oneThird = width / 3 - borderThikness;

        Widget buttons = Container(
          width: width,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).colorScheme.surface,
            //border: Border.all(width: borderThikness)
          ),
          child: Row(
            children: <Widget>[
              // plus counter
              CircleButton(
                size: oneThird,
                ontap: () => setState(increment),
                child: Icon(
                  FontAwesomeIcons.plus,
                  color: Theme.of(context).primaryColor,
                ),
              ),

              // current number
              Container(
                width: oneThird,
                height: oneThird,
                child: Center(
                  child: Text(
                    counter.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppProperties.h2,
                      color: Theme.of(context).accentColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // mine counter
              CircleButton(
                size: oneThird,
                ontap: () => setState(decrement),
                child: Icon(
                  FontAwesomeIcons.minus,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ].reversed.toList(),
          ),
        );

        List<Widget> bodyElements = [];

        if (title != null) {
          bodyElements.add(Text(
            title,
            //textScaleFactor: 0.9,
            style: TextStyle(
              fontSize: AppProperties.h3,
              //fontWeight: FontWeight.bold,
            ),
          ));
          bodyElements.add(Divider(
            thickness: 0,
            height: 10,
          ));
        }

        bodyElements.add(buttons);

        return Column(
          children: bodyElements,
        );
      },
    );
  }

  void increment() {
    counter++;
    onChange(counter);
  }

  void decrement() {
    if (counter > widget.min) counter--;
    onChange(counter);
  }
}
