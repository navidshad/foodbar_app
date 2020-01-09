import 'package:Food_Bar/models/models.dart';

abstract class ContentProvider {
  Future<List<Category>> getCategories() {
    return null;
  }

  Future<List<Food>> getFoods(String categoryId) {
    return null;
  }

  Future<List<CategoryWithFoods>> getCategoriesWithFoods()
  {
    return null;
  }
}
