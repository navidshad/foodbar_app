import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_flutter_core/interfaces/content_provider.dart';
import 'package:foodbar_flutter_core/services/services.dart';

class ContentService implements ContentProvider {
  ContentService.privateConstructor();
  static final ContentService instance = ContentService.privateConstructor();

  MongoDBService _mongodb = MongoDBService.instance;
  List<Category> categories = [];

  Future<void> updateCategories() async {
    return _mongodb
        .find(database: 'cms', collection: 'foodCategory')
        .then((docs) {
      List casted = docs as List;
      categories = [];
      for (var doc in casted) {
        var category = Category.fromMap(doc as Map, host: MongoDBService.host);
        categories.add(category);
      }
    }).catchError((error) {
      print('getCategories error ${error.toString()}');
    });
  }

  Future<List<Food>> getFoods(String category) async {
    List<Food> list = [];

    await _mongodb.find(
      database: 'cms',
      collection: 'food',
      query: {'category': category},
    ).then((dynamic docs) {
      List casted = docs as List;
      for (var doc in casted) {
        var food = Food.fromMap(doc as Map, host: MongoDBService.host);
        list.add(food);
      }
    }).catchError((error) {
      print('getFoods error ${error.toString()}');
    });

    return list;
  }

  Future<List<CategoryWithFoods>> getCategoriesWithFoods() async {
    await updateCategories();
    List<CategoryWithFoods> categoriesWithFoods = [];
    List<Future> foodRequests = [];

    categories.forEach((category) {
      foodRequests.add(getFoods(category.id));
    });

    for (var i = 0; i < categories.length; i++) {
      Category category = categories[i];
      List<Food> foods = await getFoods(category.id);
      CategoryWithFoods combined =
          CategoryWithFoods.fromCategory(category, foods: foods);
      categoriesWithFoods.add(combined);
    }

    // await Future.wait(foodRequests).then((foodRequestsResult) {
    //   for (var i = 0; i < foodRequestsResult.length; i++) {
    //     List<Food> foodsPerCategory = foodRequestsResult[i] as List<Food>;
    //     Category category = categories[i];

    //     CategoryWithFoods combined =
    //         CategoryWithFoods.fromCategory(category, foods: foodsPerCategory);
    //     categoriesWithFoods.add(combined);
    //   }
    // });

    return categoriesWithFoods;
  }

  Future<List<ReservedTable>> getReservedTables(
      {List<CustomTable> tables = const []}) {
    Map query = {'refId': _mongodb.user.id};

    return _mongodb.find(
        database: 'user',
        collection: 'reservedTable',
        query: query,
        options: {'sort': '-from', 'limit': 15}).then((list) {
      List reservedList = list as List;

      List<ReservedTable> parsedList = [];

      reservedList.forEach((detail) {
        String tableId = detail['tableId'];
        ImageDetail image;

        tables.forEach((table) {
          if (table.id == tableId) image = table.image;
        });

        ReservedTable parsed = ReservedTable.fromMap(detail, image);
        if (parsed.image != null) parsedList.add(parsed);
      });

      return parsedList;
    });
  }

  @override
  Future<List<Factor>> getFactors() {
    Map query = {'refId': _mongodb.user.id};

    return _mongodb
        .find(database: 'user', collection: 'factor', query: query)
        .then((list) {
      List factors = list as List;
      List<Factor> parsedList = [];

      factors.forEach((detail) {
        Factor parsed = Factor.fromMap(detail);
        parsedList.add(parsed);
      });

      return parsedList;
    });
  }
}
