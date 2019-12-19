import 'package:flutter/material.dart';

class OrderCounterForOneFood extends StatefulWidget {
  int count;
  Function(int newCount) onChange;

  OrderCounterForOneFood({int count, Function(int newCount) onChange}){
    this.count = count;
    this.onChange = onChange;
  }

  @override
  _OrderCounterForOneFoodState createState() =>
      _OrderCounterForOneFoodState(count, onChange);
}

class _OrderCounterForOneFoodState extends State<OrderCounterForOneFood> {
  int counter;
  Function(int newCount) onChange;

  _OrderCounterForOneFoodState(this.counter, this.onChange);

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

        return Container(
          width: width,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(width: borderThikness)
          ),
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
      },
    );
  }
}
