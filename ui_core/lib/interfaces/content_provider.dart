import 'package:foodbar_flutter_core/models/models.dart';

abstract class ContentProvider {

  List<Category> categories = [];

  Future<void> updateCategories();

  Future<List<Food>> getFoods(String categoryId);

  Future<List<CategoryWithFoods>> getCategoriesWithFoods();

  Future<List<ReservedTable>> getReservedTables({List<CustomTable> tables = const []});

  Future<List<Factor>> getFactors();
}
