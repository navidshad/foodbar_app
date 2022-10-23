import 'package:flutter/material.dart';

import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_user/settings/settings.dart';

class CardTable extends StatelessWidget {
  CardTable(
      {Key? key,
      this.table,
      this.margin,
      this.height = 200,
      this.width = 150,
      this.isActive = false,
      this.onPressed})
      : super(key: key);

  final double width;
  final double height;

  final CustomTable table;
  final EdgeInsets margin;
  final bool isActive;
  final Function(CustomTable table) onPressed;

  @override
  Widget build(BuildContext context) {
    Widget body = Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            width: width,
            height: height,
            margin: margin,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              image: DecorationImage(
                image: NetworkImage(table.image.getUrl()),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: height / 100 * 70,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.transparent,
                  // Colors.grey[900],
                  Colors.black,
                ],
              ),
            ),
            padding: EdgeInsets.all(10),
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FittedBox(
                    child: Text(
                      table.title,
                      //textScaleFactor: 0.9,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: AppProperties.h3,
                      ),
                    ),
                  ),
                  
                  if(onPressed != null)
                  Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).disabledColor,
                    ),
                    child: isActive
                        ? Icon(
                            Icons.check_circle,
                            color: Colors.lightGreenAccent,
                          )
                        : null,
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Container(
          width: width,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: body,
          ),
        ),
        onTap: () {
          onPressed(table);
        },
      ),
    );
  }
}
