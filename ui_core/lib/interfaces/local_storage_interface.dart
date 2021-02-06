import 'dart:async';

abstract class LocalStorageInterface {

  Future<void> insert(String collection, String id, Map<String, dynamic> doc, {bool allowReplace});
  Future<void> remove(String collection, String id);
  
  Future<List<Map<String, dynamic>>> find(String collection, [bool query(Map<String, dynamic> doc)]);
  Future<Map<String, dynamic>> findOne(String collection, [bool query(Map<String, dynamic> doc)]);
}