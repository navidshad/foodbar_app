import './type_caster.dart';
import 'package:foodbar_flutter_core/services/services.dart';

class Aggregate {
  MongoDBService _mongodb = MongoDBService.instance;
  String database;
  String collection;
  List<Map> pipline;

  late MongoNavigatorDetail navigatorDetail;

  Map get accessQuery {
    return {'refId': AuthService.instant?.user?.id};
  }

  List<TypeCaster> types;

  bool hasMore = false;
  bool isInitialized = false;
  bool isLive;

  int totalItems = 0;
  int perPage = 20;
  int page = 0;
  int pages = 0;

  Aggregate({
    required this.database,
    required this.collection,
    this.pipline = const [],
    this.types = const [],
    this.perPage = 20,
    this.isLive = true,
  });

  Future<void> initialize() async {
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

    navigatorDetail = MongoNavigatorDetail.calculate(
        total: totalItems, page: page, perPage: perPage);

    pages = navigatorDetail.pages;
  }

  Future<List<Map>> loadNextPage({int? goto}) async {
    if (totalItems == 0) return [];

    page += 1;
    if (goto != null) page = goto;

    navigatorDetail = MongoNavigatorDetail.calculate(
        total: totalItems, page: page, perPage: perPage);

    //print('=== SC loadNextPage $navigatorDetail | page $page');

    List<Map> nextPipeline = [
      {'\$skip': navigatorDetail.from},
      {'\$limit': navigatorDetail.to}
    ];

    nextPipeline.insertAll(0, pipline);

    List<Map> docs = [];

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

    if (page < navigatorDetail.pages)
      hasMore = true;
    else
      hasMore = false;

    return docs;
  }

  dynamic _handleError(dynamic e) {
    // print(e); // for demo purposes only
    return Exception(e);
  }
}
