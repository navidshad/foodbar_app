import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:foodbar_user/settings/app_properties.dart';
import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_user/widgets/widgets.dart';
import 'package:intl/intl.dart';

class CardReservedDetail extends StatelessWidget {
  CardReservedDetail({
    Key key,
    @required this.reservedTable,
    this.onCancel,
  }) : super(key: key);

  final ReservedTable reservedTable;
  final Function onCancel;

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).colorScheme.onSurface;
    String dateStr = DateFormat.MMMEd().format(reservedTable.from);
    String fromTime = DateFormat.jm().format(reservedTable.from);
    String toTime = DateFormat.jm().format(reservedTable.to);

    bool isPassed =
        DateTime.now().compareTo(reservedTable.from) < 0 ? false : true;

    String btnLable = 'Cnacel';

    TextStyle titleStyle = TextStyle(
        fontSize: AppProperties.h3,
        fontWeight: FontWeight.bold,
        color: textColor);

    TextStyle subtitleStyle =
        TextStyle(fontSize: AppProperties.p - 3, color: textColor);

    Widget dateDetail = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          dateStr,
          style: titleStyle,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(fromTime, style: subtitleStyle),
            Text('  To  ', style: subtitleStyle),
            Text(toTime, style: subtitleStyle),
          ],
        )
      ],
    );

    Widget persons = Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Column(
        children: <Widget>[
          Text(
            reservedTable.persons.toString(),
            textScaleFactor: 1.8,
            style: titleStyle,
          ),
          Text('Persons', style: subtitleStyle)
        ],
      ),
    );

    Widget tables = Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Column(
        children: <Widget>[
          Text(
            reservedTable.totalTable.toString(),
            textScaleFactor: 1.8,
            style: titleStyle,
          ),
          Text('Tables', style: subtitleStyle)
        ],
      ),
    );

    return CardWithCover(
      coverWithbyPersent: 40,
      imageUrl: reservedTable.image.getUrl(),
      mainAxisAlignment:
          isPassed ? MainAxisAlignment.center : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      // contentPadding: EdgeInsets.only(left: 30),
      detailwidgets: <Widget>[
        Container(
          margin: EdgeInsets.only(
            bottom: isPassed ? 0 : 20,
            left: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              dateDetail,
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  persons,
                  SizedBox(width: 20),
                  tables,
                ],
              )
            ],
          ),
        ),
        if (!isPassed)
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppProperties.cardRadius)),
            child: Material(
              color: Theme.of(context).errorColor,
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 25,
                    right: 25,
                  ),
                  child: Text(
                    btnLable,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                        fontWeight: FontWeight.bold,
                        fontSize: AppProperties.p),
                  ),
                ),
                onTap: onCancel,
              ),
            ),
          ),
      ],
    );
  }
}
