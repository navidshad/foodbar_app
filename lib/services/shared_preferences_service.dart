import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:foodbar_user/interfaces/local_storage_interface.dart';

class SharedPreferencesService implements LocalStorageInterface {
  SharedPreferencesService.privateContructor();

  static var instace = SharedPreferencesService.privateContructor();

  @override
  Future<List<Map<String, dynamic>>> find(String collection,
      [bool query(Map<String, dynamic> doc)]) async {
    //
    // get an instace of this
    SharedPreferences adapter = await SharedPreferences.getInstance();

    // define base vars
    List<Map<String, dynamic>> docs = [];
    dynamic deserialized;

    // get and data
    String jsonContent = adapter.getString(collection);
    if (jsonContent == null) return docs;

    try {
      deserialized = jsonDecode(jsonContent);
    } catch (e) {}

    if (deserialized is! List) return docs;

    // normalize the list
    deserialized.forEach((doc) {
      if (doc is Map) docs.add(doc);
    });

    // perform query
    if (query != null) docs = docs.where(query);

    return docs;
  }

  @override
  Future<Map<String, dynamic>> findOne(String collection,
      [bool query(Map<String, dynamic> doc)]) async {
    List<Map<String, dynamic>> list = await find(collection, query);

    if (list.length == 0)
      return null;
    else
      return list[0];
  }

  @override
  Future<void> insert(String collection, String id, Map<String, dynamic> doc,
      {allowReplace = false}) async {
    List<Map<String, dynamic>> list = await find(collection);

    int oldDocIndex = -1;
    
    if (list.length > 0) {
      Map<String, dynamic> oldDoc =
          list.singleWhere((d) => (d['_id'].toString() == id));
      if (allowReplace) oldDocIndex = list.indexOf(oldDoc);
    }

    doc['_id'] = id;

    // insert new
    if (oldDocIndex == -1) {
      list.add(doc);
    }

    // replace with old
    else if (allowReplace) {
      list[oldDocIndex] = doc;

      // dont add
    } else {}

    return _saveCollection(collection, list);
  }

  @override
  Future<void> remove(String collection, String id) async {
    List<Map<String, dynamic>> list = await find(collection);

    list.removeWhere((d) => (d['_id'].toString() == id));

    return _saveCollection(collection, list);
  }

  Future<void> _saveCollection(String collection, dynamic data) async {
    // get an instace of this
    SharedPreferences adapter = await SharedPreferences.getInstance();

    String serializedToJson = jsonEncode(data);

    // store
    adapter.setString(collection, serializedToJson);
  }
}
