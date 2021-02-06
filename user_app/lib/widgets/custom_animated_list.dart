import 'package:flutter/material.dart';

class RemovedItem {
  int index;
  Widget widget;

  RemovedItem({this.index, this.widget});
}

class CustomanimatedList extends StatelessWidget {
  CustomanimatedList({
    @required this.initialItemCount,
    @required this.itemBuilder,
    this.inserStream,
    this.removeStream,
    Key key,
  }) : super(key: key) {
    if (inserStream != null) inserStream.listen(inserItem);
    if (removeStream != null) removeStream.listen(removeItem);
  }

  final GlobalKey<AnimatedListState> _key = GlobalKey();
  final Function(BuildContext context, int i) itemBuilder;
  final int initialItemCount;

  final Stream<RemovedItem> removeStream;
  final Stream<int> inserStream;

  void removeItem(RemovedItem item) {
    _key.currentState.removeItem(
      item.index,
      (context, animation) {
        return FadeTransition(
          opacity: animation,
          child: item.widget,
        );
      },
    );
  }

  void inserItem(int index) async {
    // await Future.doWhile(() => _key.currentState == null);
    _key.currentState?.insertItem(index);
  }

  Widget _itemBuilder(
      BuildContext context, int i, Animation<double> animation) {
    return FadeTransition(
      opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
      child: itemBuilder(context, i),
    );
  }

  void addFristEntries() async {
    for (var i = 0; i < initialItemCount; i++) {
      await Future.delayed(Duration(milliseconds: 100));
      inserItem(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    addFristEntries();

    return AnimatedList(
      key: _key,
      initialItemCount: 0,
      itemBuilder: _itemBuilder,
    );
  }
}
