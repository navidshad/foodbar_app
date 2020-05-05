import 'package:foodbar_flutter_core/models/models.dart';

abstract class ContentProvider {
  Future<List<Category>> getCategories();

  Future<List<Food>> getFoods(String categoryId);

  Future<List<CategoryWithFoods>> getCategoriesWithFoods();

  Future<List<ReservedTable>> getReservedTables();

  Future<List<Cart>> getOrders();
}
