import 'package:Food_Bar/models/models.dart';

import 'package:Food_Bar/interfaces/content_provider.dart';

class ContentService implements ContentProvider {

  ContentService._privateConstructor();
  static final instance = ContentService._privateConstructor();

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
