import 'package:Food_Bar/models/models.dart';

abstract class ContentProvider {
  Future<List<Category>> getCategories();

  Future<List<Food>> getFoods(String categoryId);

  Future<List<CategoryWithFoods>> getCategoriesWithFoods();

  Future<List<ReservedTable>> getReservedTables();

  Future<List<Order>> getOrders();
}
