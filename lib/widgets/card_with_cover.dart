import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:foodbar_user/settings/settings.dart';

class CardWithCover extends StatefulWidget {
  CardWithCover(
      {Key key,
      this.detailwidgets = const [],
      this.coverWithbyPersent = 25,
      this.imageUrl,
      this.heroTag,
      this.onCardTap,
      this.contentPadding,
      })
      : super(key: key);

  final List<Widget> detailwidgets;
  final double coverWithbyPersent;
  final String imageUrl;
  final String heroTag;
  final Function onCardTap;
  EdgeInsetsGeometry contentPadding;

  @override
  _CardWithCoverState createState() => _CardWithCoverState();
}

class _CardWithCoverState extends State<CardWithCover>
    with AfterLayoutMixin<CardWithCover> {
  double cardHeight;
  GlobalKey _cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: _cardKey,
      builder: (con, constraints) {
        double totalWith = constraints.maxWidth;
        double coverWith = (totalWith / 100) * widget.coverWithbyPersent;
        double restWidth = totalWith - coverWith;

        Widget cardBody = Row(
          children: <Widget>[
            // thumbnail
            Hero(
              tag: widget.heroTag,
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                width: coverWith,
                height: cardHeight,
              ),
            ),

            // title & description
            Container(
              width: restWidth,
              padding: widget.contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.detailwidgets,
              ),
            )
          ],
        );

        return InkWell(
          child: Card(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(AppProperties.cardRadius)),
              child: Container(
                child: cardBody,
                color: Colors.white,
              ),
            ),
            margin: EdgeInsets.only(bottom: AppProperties.cardVerticalMargin),
            elevation: AppProperties.cardElevation,
            color: Colors.transparent,
          ),
          onTap: widget.onCardTap,
        );
      },
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    RenderBox renderBox = _cardKey.currentContext.findRenderObject();
    cardHeight = renderBox.size.height;
    setState(() {});
  }
}
