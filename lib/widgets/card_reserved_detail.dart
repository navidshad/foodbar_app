import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:foodbar_user/settings/app_properties.dart';
import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_user/widgets/widgets.dart';

class CardReservedDetail extends StatelessWidget {
  CardReservedDetail({Key key, this.reservedTable}) : super(key: key);

  final ReservedTable reservedTable;

  @override
  Widget build(BuildContext context) {
    // Widget body = Text(reservedTable.from.toIso8601String());

    Color textColor = Colors.white;
    TextStyle style = TextStyle(
        color: textColor,
        shadows: [Shadow(color: Colors.black, blurRadius: 10)]);

    Widget persons = Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Column(
        children: <Widget>[
          Text(
            reservedTable.persons.toString(),
            textScaleFactor: 4,
            style: style,
          ),
          Text(
            'Persons',
            style: style,
          )
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
            style: style,
          ),
          Text(
            'Tables',
            style: style,
          )
        ],
      ),
    );

    Column dateDetail = Column(
      children: <Widget>[
        CardDateDetail(
          backgroundColor2: Colors.transparent,
          backgroundColor: Colors.transparent,
          textColor: textColor,
          date: DateTime.now(),
          height: 100,
          width: 100,
        )
      ],
    );

    Row row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        dateDetail,
        persons,
        tables,
      ],
    );

    return Card(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius:
            BorderRadius.all(Radius.circular(AppProperties.cardRadius)),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(reservedTable.image.getUrl()),
                    fit: BoxFit.cover,
                    // colorFilter: ColorFilter.mode(
                    //   Colors.blueGrey,
                    //   BlendMode.darken,
                    // ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: 50,
              left: 50,
              bottom: 50,
              right: 50,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Container(
              child: row,
              padding: EdgeInsets.all(10),
            )
          ],
        ),
      ),
      margin: EdgeInsets.only(bottom: AppProperties.cardVerticalMargin),
      elevation: AppProperties.cardElevation,
    );
  }
}
