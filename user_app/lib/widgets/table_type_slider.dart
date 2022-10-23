import 'package:flutter/material.dart';
import 'package:foodbar_user/bloc/bloc.dart';

import 'package:foodbar_user/widgets/widgets.dart';
import 'package:foodbar_flutter_core/models/models.dart';
// import 'package:foodbar_user/settings/app_properties.dart';

class ItemAnimationDetail {
  AnimationController animator;
  Tween tween;
  Animation<double> animation;
  Curve curve;
  dynamic id;

  ItemAnimationDetail(
      {this.id, this.animator, this.tween, this.curve = Curves.easeInOut}) {
    this.animation =
        tween.animate(CurvedAnimation(parent: this.animator, curve: curve));
  }
}

class TableSlider extends StatefulWidget {
  TableSlider({
    Key? key,
    this.title,
    this.bloc,
    @required this.onPicked,
  }) : super(key: key);

  final String title;
  final ReservationBloc bloc;
  final Function(CustomTable table) onPicked;

  @override
  _TableSliderState createState() => _TableSliderState();
}

class _TableSliderState extends State<TableSlider>
    with TickerProviderStateMixin {
  int currentTableIndex = 0;
  List<CustomTable> tables;
  CustomTable selectedTable;
  bool initialCallbackCalled = false;

  List<ItemAnimationDetail> itemAnimationDetails;

  @override
  void initState() {
    widget.bloc.tableStream.listen((list) {
      tables = list;

      itemAnimationDetails = [];

      for (var i = 0; i < tables.length; i++) {
        var detail = ItemAnimationDetail(
          animator: AnimationController(
              vsync: this, duration: Duration(milliseconds: 100)),
          tween: Tween<double>(begin: 70, end: 100),
        );

        detail.animator.addListener(() {
          if (this.mounted) setState(() {});
        });

        itemAnimationDetails.add(detail);
      }

      if (tables.length > 0) onPageChanged(1);

      if (this.mounted) setState(() {});
    });

    widget.bloc.eventSink.add(GetTables());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget state;
    if (tables == null) {
      state = Center(child: CircularProgressIndicator());
    } else {
      state = LayoutBuilder(
        builder: (context, constraints) {
          double totalWith = constraints.maxWidth;
          double totalHeight = constraints.maxHeight;
          double cardSidePadding = 10;
          double cardWith = (totalWith / 1.1) - cardSidePadding;
          double cardHeight = (totalHeight / 1) - cardSidePadding;
          double viewportFraction = (totalWith / 0.5) / 1000;

          return Container(
            child: PageView.builder(
              itemCount: tables.length,
              controller: PageController(
                viewportFraction: viewportFraction,
                initialPage: currentTableIndex,
              ),
              onPageChanged: onPageChanged,
              itemBuilder: (context, index) {
                var itemAnimationDetail = itemAnimationDetails[index];
                var table = tables[index];
                return Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: cardSidePadding, right: cardSidePadding),
                    child: Align(
                      alignment: Alignment.center,
                      child: CardTable(
                        height: (cardHeight / 100) *
                            itemAnimationDetail.animation.value,
                        width: (cardWith / 100) *
                            itemAnimationDetail.animation.value,
                        table: table,
                        //margin: EdgeInsets.only(left: cardSidePadding, right: cardSidePadding),
                        isActive: (ReservationBloc.selectedTable?.id == table.id),
                        onPressed: (table) {
                          widget.onPicked(table);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    }

    return state;
  }

  void onPageChanged(pageIndex) {
    currentTableIndex = pageIndex;

    for (var i = 0; i < itemAnimationDetails.length; i++) {
      var animationDetail = itemAnimationDetails[i];
      if (i == currentTableIndex)
        animationDetail.animator.forward();
      else
        animationDetail.animator.reverse();
    }
  }
}
