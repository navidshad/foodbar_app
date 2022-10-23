import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodbar_admin/bloc/collection_editor_bloc.dart';

import 'package:foodbar_admin/bloc/bloc.dart';
import 'package:foodbar_admin/settings/types.dart';
import 'package:foodbar_admin/widgets/widgets.dart';
import 'package:foodbar_flutter_core/mongodb/field.dart';

class CollectionEditorTab extends StatefulWidget {
  CollectionEditorTab(
      {Key? key,
      required this.database,
      required this.collection,
      this.getDbFieldsMethod,
      this.getDbFieldsMethodByFuture,
      required this.tabTypeStream,
      required this.type,
      this.onOperation,
      this.query = const {},
      this.allowInsert = true,
      this.allowRemove = true,
      this.allowUpdate = true,
      this.hasImage = false})
      : super(key: key);

  final String database;
  final String collection;
  final bool allowInsert;
  final bool allowRemove;
  final bool allowUpdate;
  final bool hasImage;

  final Function? getDbFieldsMethod;

  /// this function must return a Future
  final Future? getDbFieldsMethodByFuture;
  final Stream<FrameTabType> tabTypeStream;
  final FrameTabType type;
  final Map query;
  final Function(
          CollectionEditorBlocEvent event, StreamSink<bool> setStateSink)?
      onOperation;

  @override
  _CollectionEditorTabState createState() => _CollectionEditorTabState();
}

class _CollectionEditorTabState extends State<CollectionEditorTab> {
  StreamController<bool> _setStateStream = StreamController();
  late CollectionEditorBloc bloc;
  bool allowTogetDocs = false;
  List<DbField> dbFields = [];

  @override
  void initState() {
    super.initState();
    widget.tabTypeStream.listen(onTabTypeReceived);

    _setStateStream.stream.listen((bool key) {
      if (key) setState(() {});
    });

    if (widget.getDbFieldsMethod != null) {
      dbFields = widget.getDbFieldsMethod!();
    } else if (widget.getDbFieldsMethodByFuture != null) {
      Future.wait([widget.getDbFieldsMethodByFuture!]).then((resultList) {
        dbFields = resultList.last as List<DbField>;
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _setStateStream.close();
    super.dispose();
  }

  void onTabTypeReceived(FrameTabType currentType) {
    if (currentType != widget.type) return;
    allowTogetDocs = true;
  }

  void getDocs() {
    var event =
        GetDocsEvent(page: bloc.navigatorDetail.page, query: widget.query);
    bloc.eventSink.add(event);
  }

  @override
  Widget build(BuildContext context) {
    // create bloc
    if (bloc == null) {
      bloc = CollectionEditorBloc(
          database: widget.database, collection: widget.collection);

      bloc.operationStream.listen((event) {
        if (widget.onOperation != null)
          widget.onOperation!(event, _setStateStream.sink);
      });
    }

    if (allowTogetDocs) getDocs();

    Widget editor;

    if (dbFields == null)
      editor = Center(child: CircularProgressIndicator());
    else {
      editor = BlocProvider(
        bloc: bloc,
        child: CollectionEditor(
          dbFields: dbFields,
          allowInsert: widget.allowInsert,
          allowRemove: widget.allowRemove,
          allowUpdate: widget.allowUpdate,
          hasImage: widget.hasImage,
          query: widget.query,
        ),
      );
    }

    return editor;
  }
}
