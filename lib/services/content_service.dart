import 'package:Food_Bar/models/models.dart';

import 'package:Food_Bar/interfaces/content_provider.dart';

class ContentService implements ContentProvider {
  Future<List<Category>> getCategories() {
    return null;
  }

  Future<List<Food>> getFoods(String category) {
    return null;
  }

  Future<List<CategoryWithFoods>> getCategoriesWithFoods()
  {
    return null;
  }
}
