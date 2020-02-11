import './type_caster.dart';
import 'package:Food_Bar/services/services.dart';

class Aggregate {
  MongoDBService _mongodb;
  String database;
  String collection;
  List<Map> pipline;
  Map accessQuery;

  List<TypeCaster> types;

  bool hasMore = false;
  bool isInitialized = false;
  bool isLive;

  int totalItems = 0;
  int perPage = 20;
  int page = 0;
  int pages = 0;

  Aggregate(
      {this.database,
      this.collection,
      this.pipline = const [],
      this.accessQuery = const {},
      this.types,
      this.perPage = 20,
      this.isLive = true}) {
    //_mongodb = Injector.get<MongoDBService>();
  }

  Future<dynamic> initialize() async {
    // get count ============================
    List<Map> countPipeline = [
      {"\$count": "count"}
    ];

    countPipeline.insertAll(0, pipline);

    await _mongodb
        .aggregate(
            database: database,
            collection: collection,
            piplines: countPipeline,
            accessQuery: accessQuery,
            types: types)
        .then((docs) {
      if (docs.length > 0) totalItems = docs[0]['count'];
    }).catchError(_handleError);

    isInitialized = true;

    Map navigatorDetail =
        getNavigatorDetail(total: totalItems, page: page, perPage: perPage);
    pages = navigatorDetail['pages'];
  }

  Future<List<dynamic>> loadNextPage({int goto}) async {
    if (totalItems == 0) return [];

    page += 1;
    if (goto != null) page = goto;

    Map navigatorDetail =
        getNavigatorDetail(total: totalItems, page: page, perPage: perPage);
    //print('=== SC loadNextPage $navigatorDetail | page $page');

    List<Map> nextPipeline = [
      {'\$skip': navigatorDetail['from']},
      {'\$limit': navigatorDetail['to']}
    ];

    nextPipeline.insertAll(0, pipline);

    List<dynamic> docs = [];

    await _mongodb
        .aggregate(
            isLive: isLive,
            database: database,
            collection: collection,
            piplines: nextPipeline,
            accessQuery: accessQuery,
            types: types)
        .then((list) => docs = list)
        .catchError(_handleError);

    if (page < navigatorDetail['pages'])
      hasMore = true;
    else
      hasMore = false;

    return docs;
  }

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Aggregate error; cause: $e');
  }
}
