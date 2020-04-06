import 'package:flutter/material.dart';

import 'package:foodbar_user/widgets/widgets.dart';
import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_user/settings/app_properties.dart';

class TableSlider extends StatefulWidget {
  TableSlider(
      {Key key, this.title, this.tables = const [], @required this.onPicked})
      : super(key: key);

  final String title;
  final List<CustomTable> tables;
  final Function(CustomTable table) onPicked;

  @override
  _TableSliderState createState() => _TableSliderState();
}

class _TableSliderState extends State<TableSlider> {
  int selectedDayIndex = 0;
  CustomTable selectedTable;
  bool initialCallbackCalled = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        List<Widget> bodyColumnWidgets = [];

        // create cards -----------
        double cardMargin = 4;
        List<Widget> cards = [];

        for (int i = 0; i < widget.tables.length; i++) {
          CustomTable table = widget.tables[i];

          if (i == selectedDayIndex) selectedTable = table;

          if (!initialCallbackCalled) widget.onPicked(selectedTable);

          cards.add(CardTable(
            table: table,
            margin: EdgeInsets.all(cardMargin),
            isActive: (selectedDayIndex == i),
            onPressed: (table) {
              selectedDayIndex = i;
              setState(() {});
              widget.onPicked(table);
            },
          ));
        }

        // Title -----
        Widget titleWidget = Container(
          margin: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.title ?? '',
                textScaleFactor: 1.5,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );

        if (widget.title != null) bodyColumnWidgets.add(titleWidget);

        // Slider ------
        SingleChildScrollView daysSectionWidget = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: cards,
            ),
          ),
        );

        bodyColumnWidgets.add(daysSectionWidget);

        return Container(
          height: 300,
          child: Column(
            children: bodyColumnWidgets,
          ),
        );
      },
    );
  }
}
