import 'package:flutter/material.dart';

import 'package:foodbar_flutter_core/mongodb/navigator.dart';

class CollectionEditorActionButtons extends StatefulWidget {
  CollectionEditorActionButtons({
    Key? key,
    required this.allowInsert,
    required this.onAddItem,
    required this.onRefresh,
    required this.onPrevious,
    required this.onNext,
    required this.navigatorDetail,
  }) : super(key: key);

  final Function onAddItem;
  final Function onRefresh;
  final Function onPrevious;
  final Function onNext;

  final bool allowInsert;
  final MongoNavigatorDetail navigatorDetail;

  @override
  _CollectionEditorActionButtonsState createState() =>
      _CollectionEditorActionButtonsState();
}

class _CollectionEditorActionButtonsState
    extends State<CollectionEditorActionButtons> with TickerProviderStateMixin {
  late AnimationController _animControllerOptions;
  late AnimationController _animControllerActions;

  @override
  void initState() {
    _animControllerOptions = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _animControllerActions = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget add = Container(
      margin: EdgeInsets.only(bottom: 5),
      width: 85,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ScaleTransition(
            scale: Tween(begin: 0.0, end: 1.0).animate(_animControllerActions),
            child: Text(
              'Add Item',
              textScaleFactor: 0.6,
            ),
          ),
          ScaleTransition(
            scale: Tween(begin: 0.0, end: 1.0).animate(_animControllerActions),
            child: Container(
              width: 40,
              child: FloatingActionButton(
                heroTag: 'Add Item',
                child: Icon(Icons.add),
                onPressed: () => widget.onAddItem(),
              ),
            ),
          )
        ],
      ),
    );

    Widget refresh = Container(
      margin: EdgeInsets.only(bottom: 5),
      width: 85,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ScaleTransition(
            scale: Tween(begin: 0.0, end: 1.0).animate(_animControllerActions),
            child: Text(
              'Refresh',
              textScaleFactor: 0.6,
            ),
          ),
          ScaleTransition(
            scale: Tween(begin: 0.0, end: 1.0).animate(_animControllerActions),
            child: Container(
              width: 40,
              child: FloatingActionButton(
                heroTag: 'Refresh',
                child: Icon(Icons.refresh),
                onPressed: () => widget.onRefresh(),
              ),
            ),
          )
        ],
      ),
    );

    Widget previous = Container(
      margin: EdgeInsets.only(bottom: 5),
      width: 85,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ScaleTransition(
            scale: Tween(begin: 0.0, end: 1.0).animate(_animControllerActions),
            child: Text(
              'Previous',
              textScaleFactor: 0.6,
            ),
          ),
          ScaleTransition(
            scale: Tween(begin: 0.0, end: 1.0).animate(_animControllerActions),
            child: Container(
              width: 40,
              child: FloatingActionButton(
                heroTag: 'Previous',
                child: Icon(Icons.arrow_back),
                onPressed: () => widget.onPrevious(),
              ),
            ),
          )
        ],
      ),
    );

    Widget next = Container(
      margin: EdgeInsets.only(bottom: 20),
      width: 85,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ScaleTransition(
            scale: Tween(begin: 0.0, end: 1.0).animate(_animControllerActions),
            child: Text(
              'Next',
              textScaleFactor: 0.6,
            ),
          ),
          ScaleTransition(
            scale: Tween(begin: 0.0, end: 1.0).animate(_animControllerActions),
            child: Container(
              width: 40,
              child: FloatingActionButton(
                heroTag: 'next',
                child: Icon(Icons.arrow_forward),
                onPressed: () => widget.onNext(),
              ),
            ),
          )
        ],
      ),
    );

    Widget options = RotationTransition(
      turns: Tween<double>(begin: 0, end: 0.3).animate(_animControllerOptions),
      child: FloatingActionButton(
        child: Icon(Icons.settings),
        onPressed: () {
          if (_animControllerOptions.isCompleted) {
            _animControllerActions.reverse();
            _animControllerOptions.reverse();
          } else {
            _animControllerActions.forward();
            _animControllerOptions.forward();
          }
        },
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (widget.allowInsert) add,
        refresh,
        if (widget.navigatorDetail.hasPrevious) previous,
        if (widget.navigatorDetail.hasNext) next,
        options,
      ],
    );
  }
}
