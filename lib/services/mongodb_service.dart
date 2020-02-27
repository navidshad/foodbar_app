import 'package:Foodbar_user/interfaces/auth_interface.dart';
import 'package:Foodbar_user/services/auth_service.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';

import 'package:Foodbar_user/settings/static_vars.dart';
import 'package:Foodbar_user/services/services.dart';
import 'package:Foodbar_user/models/user.dart';
export 'package:Foodbar_user/mongodb/mongodb.dart';

class MongoDBService {
  Client _http = Client();
  AuthInterface _userService = AuthService.instant;
  User get user => _userService.user;

  MongoDBService.privateConstructor();
  static MongoDBService instance = MongoDBService.privateConstructor();

  Future<Map<String, String>> _getHeaders([isLive = true]) async {
    await Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 500));
      if (_userService.token == null)
        return true;
      else
        return false;
    });

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': _userService.token
    };

    if (isLive) headers['live'] = 'true';

    return headers;
  }

  Future<dynamic> find(
      {bool isLive = true,
      String database,
      String collection,
      Map query = const {},
      Map options = const {},
      List<TypeCaster> types = const []}) async {
    String url = Vars.host + '/contentProvider/find';

    Map body = {
      'database': database,
      'collection': collection,
      'query': query,
      'options': options,
      'bodyKey': 'query',
      'types': [],
    };

    if (types != null) types.forEach((tc) => body['types'].add(tc.getMap()));

    Map<String, String> headers = await _getHeaders(isLive);

    return _http
        .post(url, body: json.encode(body), headers: headers)
        .then(analizeResult);
  }

  Future<dynamic> findOne(
      {bool isLive = true,
      String database,
      String collection,
      Map query = const {},
      Map options = const {},
      List<TypeCaster> types = const []}) async {
    String url = Vars.host + '/contentProvider/findOne';

    dynamic body = {
      'database': database,
      'collection': collection,
      'query': query,
      'options': options,
      'bodyKey': 'query',
      'types': [],
    };

    if (types != null) types.forEach((tc) => body['types'].add(tc.getMap()));

    Map<String, String> headers = await _getHeaders(isLive);

    return _http
        .post(url, body: json.encode(body), headers: headers)
        .then(analizeResult);
  }

  Future<dynamic> count(
      {bool isLive = true,
      String database,
      String collection,
      Map query = const {},
      String bodyKey = '',
      List<TypeCaster> types = const []}) async {
    String url = Vars.host + '/contentProvider/count';

    dynamic body = {
      'database': database,
      'collection': collection,
      'query': query,
      'bodyKey': bodyKey,
      'types': [],
    };

    if (types != null) types.forEach((tc) => body['types'].add(tc.getMap()));

    Map<String, String> headers = await _getHeaders(isLive);

    return _http
        .post(url, body: json.encode(body), headers: headers)
        .then(analizeResult)
        .catchError((e) => 0);
  }

  Future<dynamic> updateOne(
      {bool isLive = true,
      String database,
      String collection,
      Map query,
      Map update,
      Map options = const {}}) async {
    String url = Vars.host + '/contentProvider/updateOne';

    dynamic body = {
      'database': database,
      'collection': collection,
      'query': query,
      'update': update,
      'options': options
    };

    Map<String, String> headers = await _getHeaders(isLive);

    return _http
        .post(url, body: json.encode(body), headers: headers)
        .then(analizeResult);
  }

  Future<dynamic> insertOne(
      {bool isLive = true, String database, String collection, Map doc}) async {
    String url = Vars.host + '/contentProvider/insertOne';

    dynamic body = {
      'database': database,
      'collection': collection,
      'doc': doc,
    };

    Map<String, String> headers = await _getHeaders(isLive);

    return _http
        .post(url, body: json.encode(body), headers: headers)
        .then(analizeResult);
  }

  Future<dynamic> removeOne(
      {bool isLive = true,
      String database,
      String collection,
      Map query}) async {
    String url = Vars.host + '/contentProvider/removeOne';

    dynamic body = {
      'database': database,
      'collection': collection,
      'query': query,
    };

    Map<String, String> headers = await _getHeaders(isLive);

    return _http
        .post(url, body: json.encode(body), headers: headers)
        .then(analizeResult);
  }

  Future<dynamic> aggregate(
      {bool isLive = true,
      String database,
      String collection,
      List<Map> piplines,
      Map accessQuery = const {},
      List<TypeCaster> types = const []}) async {
    String url = Vars.host + '/contentProvider/aggregate';

    dynamic body = {
      'database': database,
      'collection': collection,
      'piplines': piplines,
      'accessQuery': accessQuery,
      'bodyKey': 'piplines',
      'types': [],
    };

    if (types != null) types.forEach((tc) => body['types'].add(tc.getMap()));

    Map<String, String> headers = await _getHeaders(isLive);

    return _http
        .post(url, body: json.encode(body), headers: headers)
        .then(analizeResult);
  }

  Future<dynamic> findByIds(
      {bool isLive = true,
      String database,
      String collection,
      Map options = const {},
      List<String> ids}) async {
    String url = Vars.host + '/contentProvider/getByIds';

    dynamic body = {
      'database': database,
      'collection': collection,
      'options': options,
      'IDs': ids,
    };

    Map<String, String> headers = await _getHeaders(isLive);

    return _http
        .post(url, body: json.encode(body), headers: headers)
        .then(analizeResult);
  }

  Future<dynamic> findById(
      {bool isLive = true,
      String database,
      String collection,
      String id,
      Map options = const {}}) async {
    dynamic body = {
      'database': database,
      'collection': collection,
      'query': {'_id': id},
    };

    return findOne(
        database: database,
        collection: collection,
        query: body,
        options: options);
  }

  dynamic _convert(String jsonString) => jsonDecode(jsonString);

  dynamic analizeResult(Response r) {
    if (r.statusCode != 200) {
      print('== analizeResult mongo service err ${r.statusCode} ${r.body}');
      throw new StateError(r.body);
    }
    return _convert(r.body);
  }
}
