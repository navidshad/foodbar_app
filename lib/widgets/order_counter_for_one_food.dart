import 'package:flutter/material.dart';

class OrderCounterForOneFood extends StatefulWidget {
  int count;
  Function(int newCount) onChange;
  String title;

  OrderCounterForOneFood({this.count, this.onChange, this.title});

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
        double borderThikness = 0.1;
        double defaultWidth = 80;
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
              border: Border.all(width: borderThikness)),
          child: Row(
            children: <Widget>[
              // plus counter
              Container(
                width: oneThird,
                height: oneThird,
                child: OutlineButton(
                  child: Center(
                    child: Text(
                      '+',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onPressed: () {
                    counter++;
                    setState(() {});
                  },
                ),
              ),

              // plus counter
              Container(
                width: oneThird,
                height: oneThird,
                child: Center(
                  child: Text(
                    counter.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // mine counter
              Container(
                width: oneThird,
                height: oneThird,
                child: OutlineButton(
                  child: Center(
                    child: Text(
                      '-',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onPressed: () {
                    counter--;
                    setState(() {});
                  },
                ),
              )
            ],
          ),
        );

        List<Widget> bodyElements = [];

        if (title != null) {
          bodyElements.add(Text(
            title,
            textScaleFactor: 0.9,
            style: TextStyle(fontWeight: FontWeight.bold),
          ));
          bodyElements.add(Divider(thickness: 0, height: 10,));
        }

        bodyElements.add(buttons);

        return Column(
          children: bodyElements,
        );
      },
    );
  }
}
