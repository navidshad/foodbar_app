import 'package:flutter/material.dart';

import 'package:Food_Bar/settings/app_properties.dart';
import 'package:Food_Bar/models/models.dart';

class CardReservedDetail extends StatelessWidget {
  CardReservedDetail({Key key, this.reservedTable}) : super(key: key);

  final ReservedTable reservedTable;

  @override
  Widget build(BuildContext context) {
    Widget body = Text(reservedTable.from.toIso8601String());

    Widget persons = Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Column(
        children: <Widget>[
          Text(
            reservedTable.persons.toString(),
            textScaleFactor: 4,
          ),
          Text('Persons')
        ],
      ),
    );

    Widget tables = Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Column(
        children: <Widget>[
          Text(
            reservedTable.totalTable.toString(),
            textScaleFactor: 4,
          ),
          Text('Tables')
        ],
      ),
    );

    Row row = Row(
      children: <Widget>[
        tables,
        persons,
      ],
    );

    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          child: row,
          padding: EdgeInsets.all(10),
        ),
      ),
      margin: EdgeInsets.only(bottom: AppProperties.cardVerticalMargin),
      elevation: AppProperties.cardElevation,
    );
  }
}
