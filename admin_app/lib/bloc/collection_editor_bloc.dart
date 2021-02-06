import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:foodbar_admin/bloc/bloc.dart';
import 'package:foodbar_admin/services/options_service.dart';
import 'package:foodbar_admin/services/services.dart';
import 'package:foodbar_flutter_core/interfaces/bloc_interface.dart';
import 'package:foodbar_flutter_core/mongodb/navigator.dart';
import 'package:foodbar_flutter_core/services/mongodb_service.dart';
import 'package:rxdart/rxdart.dart';

class CollectionEditorBloc
    implements
        BlocInterface<CollectionEditorBlocEvent, CollectionEditorBlocState> {
  StreamController<CollectionEditorBlocEvent> _eventController =
      BehaviorSubject();
  StreamController<CollectionEditorBlocState> _stateController =
      BehaviorSubject();

  StreamController<bool> _pendingController = BehaviorSubject();
  StreamController<StateError> _exceptionController = BehaviorSubject();
  StreamController<MongoNavigatorDetail> _navigatorController =
      BehaviorSubject();

  String database;
  String collection;

  MongoDBService _mongodb = MongoDBService.instance;
  MongoNavigatorDetail navigatorDetail = MongoNavigatorDetail();
  ImageService _imageService = ImageService.instance;

  CollectionEditorBloc({@required this.database, @required this.collection}) {
    _eventController.stream.listen(handler);
  }

  Stream<CollectionEditorBlocEvent> get operationStream =>
      _eventController.stream;
  Stream<bool> get pendingStream => _pendingController.stream;
  Stream<StateError> get exceptionStream => _exceptionController.stream;
  Stream<MongoNavigatorDetail> get navigatorStream =>
      _navigatorController.stream;

  @override
  StreamSink<CollectionEditorBlocEvent> get eventSink => _eventController.sink;

  @override
  Stream<CollectionEditorBlocState> get stateStream => _stateController.stream;

  @override
  CollectionEditorBlocState getInitialState() {
    return CollectionEditorBlocState(navigatorDetail: MongoNavigatorDetail());
  }

  dynamic errorHandler(dynamic error) {
    // print(error.toString());
    //_exceptionController.add(error);
    return Exception(error);
  }

  @override
  void handler(CollectionEditorBlocEvent event) async {
    //print('_pendingController true');
    _pendingController.add(true);

    // get docs
    if (event is GetDocsEvent) {
      int total = AppProperties.mongodbTotalPerPage;
      int page = event.page;

      //print('page $page');

      Aggregate aggregate = Aggregate(
        database: database,
        collection: collection,
        perPage: total,
        types: event.types,
        pipline: [
          {'\$match': event.query}
        ],
      );

      await aggregate
          .initialize()
          .then((r) {
            aggregate.loadNextPage(goto: page).then((docs) {
              navigatorDetail = aggregate.navigatorDetail;
              CollectionEditorBlocState state = CollectionEditorBlocState(
                docs: docs,
                navigatorDetail: navigatorDetail,
              );
              _stateController.add(state);
              _navigatorController.add(navigatorDetail);
            }).catchError(errorHandler);
          })
          .catchError(errorHandler)
          .catchError((err) {
            if (event.onError != null) event.onError(err);
          });
    }

    //create dic
    else if (event is CreateDocEvent) {
      await _mongodb
          .insertOne(
            database: database,
            collection: collection,
            doc: event.doc,
          )
          .catchError(errorHandler)
          .catchError((err) {
        if (event.onError != null) event.onError(err);
      });
    }

    // update a doc
    else if (event is UpdateDocEvent) {
      await _mongodb
          .updateOne(
            database: database,
            collection: collection,
            query: event.query,
            update: event.update,
            options: event.options,
          )
          .catchError(errorHandler)
          .catchError((err) {
        if (event.onError != null) event.onError(err);
      });
    }

    // remove docs
    else if (event is RemoveDocsEvent) {
      await _mongodb
          .removeOne(
            database: database,
            collection: collection,
            query: event.query,
          )
          .catchError(errorHandler)
          .catchError((err) {
        if (event.onError != null) event.onError(err);
      });
    }

    // upload image
    else if (event is UploadImageEvent) {
      await _imageService
          .upload(
        database: database,
        collection: collection,
        id: event.id,
        file: event.file,
        onTransform: event.onTransform,
      )
          .catchError((err) {
        if (event.onError != null) event.onError(err);
      });
    }

    if (event.onDone != null) event.onDone();

    await Future.delayed(Duration(seconds: 1));
    _pendingController.add(false);
  }

  @override
  void dispose() {
    print('dispose $database $collection');
    _eventController.close();
    _stateController.close();
    _navigatorController.close();
    _exceptionController.close();
  }
}

class CollectionEditorBlocEvent {
  Function _onDone;
  Function(dynamic error) _onError;
  bool wasErrorHapened = false;

  CollectionEditorBlocEvent(
      {Function onDone, Function(dynamic error) onError}) {
    _onDone = onDone;
    _onError = onError;
  }

  void onDone() {
    if (wasErrorHapened) return;

    if (_onDone != null) _onDone();
  }

  void onError(dynamic error) {
    wasErrorHapened = true;

    if (_onError != null) _onError(error);
  }
}

class GetDocsEvent extends CollectionEditorBlocEvent {
  int page;
  Map query;
  Map<dynamic, dynamic> options;
  List<TypeCaster> types;

  GetDocsEvent({
    this.page = 1,
    this.query = const {},
    this.options = const {},
    this.types = const [],
    Function onDone,
    Function(dynamic error) onError,
  }) : super(onDone: onDone, onError: onError);
}

class CreateDocEvent extends CollectionEditorBlocEvent {
  Map<dynamic, dynamic> doc;
  CreateDocEvent({
    this.doc,
    Function onDone,
    Function(dynamic error) onError,
  }) : super(onDone: onDone, onError: onError);
}

class UpdateDocEvent extends CollectionEditorBlocEvent {
  Map<dynamic, dynamic> query;
  Map<dynamic, dynamic> update;
  Map<dynamic, dynamic> options;

  UpdateDocEvent({
    this.query,
    this.update,
    this.options = const {},
    Function onDone,
    Function(dynamic error) onError,
  }) : super(onDone: onDone, onError: onError);
}

class RemoveDocsEvent extends CollectionEditorBlocEvent {
  Map<dynamic, dynamic> query;
  RemoveDocsEvent({
    this.query,
    Function onDone,
    Function(dynamic error) onError,
  }) : super(onDone: onDone, onError: onError);
}

class UploadImageEvent extends CollectionEditorBlocEvent {
  String id;
  File file;
  Function(int percent) onTransform;
  UploadImageEvent({
    this.id,
    this.file,
    this.onTransform,
    Function onDone,
    Function(dynamic error) onError,
  }) : super(onDone: onDone, onError: onError);
}

class CollectionEditorBlocState {
  List<Map> docs;
  MongoNavigatorDetail navigatorDetail;
  CollectionEditorBlocState({this.docs = const [], this.navigatorDetail});
}
