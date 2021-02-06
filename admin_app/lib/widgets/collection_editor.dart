import 'package:flutter/material.dart';

import 'package:foodbar_admin/bloc/bloc.dart';
import 'package:foodbar_admin/screens/screen_add_or_edit_item.dart';
import 'package:foodbar_flutter_core/mongodb/field.dart';
import 'package:foodbar_admin/widgets/widgets.dart';
import 'package:foodbar_flutter_core/mongodb/mongodb.dart';

class CollectionEditor extends StatefulWidget {
  CollectionEditor({
    Key key,
    @required this.dbFields,
    this.query = const {},
    this.allowInsert = true,
    this.allowRemove = true,
    this.allowUpdate = true,
    this.hasImage = false,
  }) : super(key: key);

  final bool allowInsert;
  final bool allowRemove;
  final bool allowUpdate;
  final bool hasImage;
  final List<DbField> dbFields;
  final Map query;

  @override
  _CollectionEditorState createState() => _CollectionEditorState();
}

class _CollectionEditorState extends State<CollectionEditor> {
  CollectionEditorBloc bloc;
  BuildContext _context;
  MongoNavigatorDetail navigatorDetail = MongoNavigatorDetail();
  bool isPending = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (bloc != null) return;

    bloc = BlocProvider.of<CollectionEditorBloc>(context);

    bloc.navigatorStream.listen((nd) {
      navigatorDetail = nd;
      setState(() {});
    });

    bloc.pendingStream.listen((pendingKey) {
      isPending = pendingKey;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    if (bloc == null)
      throw Exception(
          'CollectionEditor needs a CollectionEditorBloc as an ancestor.');

    return Scaffold(
      floatingActionButton: CollectionEditorActionButtons(
        allowInsert: widget.allowInsert,
        onAddItem: onAddItem,
        onRefresh: onRefresh,
        onPrevious: onPrevious,
        onNext: onNext,
        navigatorDetail: navigatorDetail,
      ),
      body: LayoutBuilder(
        builder: (layoutBuilderContext, constraints) {
          double navigatorHeight = 50;
          double detailSectionHeight = constraints.maxHeight - navigatorHeight;

          return Column(
            children: <Widget>[
              if (!isPending)
                StreamBuilder<CollectionEditorBlocState>(
                    stream: bloc.stateStream,
                    initialData: bloc.getInitialState(),
                    builder: (con, snapshot) {
                      CollectionEditorBlocState state = snapshot.data;

                      return Container(
                        height: detailSectionHeight,
                        child: CollectionTableViewer(
                          dbFields: widget.dbFields,
                          onFieldTap: onFieldTap,
                          docs: state.docs,
                          bloc: bloc,
                        ),
                      );
                    }),
              if (isPending)
                Container(
                  height: detailSectionHeight,
                  child: Center(child: CircularProgressIndicator()),
                ),
              Container(
                height: navigatorHeight,
                child: getNavigatorViewer(),
              )
            ],
          );
        },
      ),
    );
  }

  void onAddItem() async {
    var router = MaterialPageRoute<Map>(
        builder: (contx) => AddOrEditeItem(
              dbFields: widget.dbFields,
              hasImage: widget.hasImage,
              bloc: bloc,
            ));

    await Navigator.of(_context).push<Map>(router);

    onRefresh();
  }

  void editDoc(Map doc) async {
    var router = MaterialPageRoute<Map>(
        builder: (contx) => AddOrEditeItem(
            dbFields: widget.dbFields,
            hasImage: widget.hasImage,
            editingDoc: doc,
            isNew: false,
            bloc: bloc));

    await Navigator.of(_context).push<Map>(router);

    onRefresh();
  }

  void onRefresh() {
    var event =
        GetDocsEvent(page: bloc.navigatorDetail.page, query: widget.query);
    bloc.eventSink.add(event);
  }

  void onPrevious() {
    var event =
        GetDocsEvent(page: bloc.navigatorDetail.previous, query: widget.query);
    bloc.eventSink.add(event);
  }

  void onNext() {
    var event =
        GetDocsEvent(page: bloc.navigatorDetail.next, query: widget.query);
    bloc.eventSink.add(event);
  }

  void onFieldTap(Map doc) {
    if (!widget.allowUpdate && !widget.allowRemove) return;

    showDialog(
        context: _context,
        barrierDismissible: true,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              'Item Options',
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              if (widget.allowUpdate)
                FlatButton(
                  onPressed: () {
                    Navigator.of(con).pop();
                    editDoc(doc);
                  },
                  child: Text('Edit it'),
                ),
              if (widget.allowRemove)
                FlatButton(
                  onPressed: () {
                    Navigator.of(con).pop();
                    askToRemoveDoc(doc);
                  },
                  child: Text('Remove it'),
                ),
            ],
          );
        });
  }

  void askToRemoveDoc(Map doc) {
    showDialog(
        context: _context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            content: Text(
              'Do you want to remove this item?',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  removeDoc(doc);
                },
                child: Text('Yes'),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('no'),
              ),
            ],
          );
        });
  }

  void removeDoc(Map doc) {
    var event = RemoveDocsEvent(query: {'_id': doc['_id']}, onDone: onRefresh);
    bloc.eventSink.add(event);
  }

  Widget getNavigatorViewer() {
    return LayoutBuilder(
      builder: (con, constraints) {
        double sectionWide = constraints.maxWidth / 3;

        Widget pending;
        if (isPending)
          pending = Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 1),
            ),
          );
        else
          pending = Icon(
            Icons.data_usage,
            color: Colors.green,
          );

        Row row = Row(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(width: sectionWide, child: pending),

            // page detail
            Container(
              width: sectionWide,
              child: Text(
                  '${navigatorDetail.page} OF ${navigatorDetail.pages} Pages'),
            ),

            // nothing
            // Container(
            //   width: sectionWide,

            // )
          ],
        );

        return row;
      },
    );
  }
}
