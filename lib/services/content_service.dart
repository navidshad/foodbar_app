import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/interfaces/content_provider.dart';
import 'package:Food_Bar/services/services.dart';

class ContentService implements ContentProvider {
  ContentService._privateConstructor();
  static final instance = ContentService._privateConstructor();

  MongoDBService _mongodb = MongoDBService.instance;

  Future<List<Category>> getCategories() {
    return null;
  }

  Future<List<Food>> getFoods(String category) {
    return null;
  }

  Future<List<CategoryWithFoods>> getCategoriesWithFoods() {
    return null;
  }

  Future<List<ReservedTable>> getReservedTables() {
    Map query = {'refId': _mongodb.user.id};

    return _mongodb
        .find(database: 'user', collection: 'reservedTable', query: query)
        .then((list) {
      List reservedList = list as List;

      List<ReservedTable> parsedList = [];

      reservedList.forEach((detail) {
        ReservedTable parsed = ReservedTable.fromMap(detail);
        parsedList.add(parsed);
      });

      return parsedList;
    });
  }

  @override
  Future<List<Order>> getOrders() {
    Map query = {'refId': _mongodb.user.id};

    return _mongodb
        .find(database: 'user', collection: 'order', query: query)
        .then((list) {
      List orderList = list as List;

      List<Order> parsedList = [];

      orderList.forEach((detail) {
        Order parsed = Order.fromMap(detail);
        parsedList.add(parsed);
      });

      return parsedList;
    });
  }
}
