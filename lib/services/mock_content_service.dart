import 'dart:math';

import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/interfaces/content_provider.dart';

class MockContentService implements ContentProvider {
  Future<List<Category>> getCategories() {
    return Future.delayed(Duration(seconds: 2)).then((r) => mockCategories
        .map((cat) => cat..imageUrl = getRandomImage('header'))
        .toList());
  }

  Future<List<Food>> getFoods(String category) {
    return Future.delayed(Duration(seconds: 2)).then((r) => mockFoods
        .where((item) => item.categoryId == category)
        .toList()
        .map((food) => food..imageUrl = getRandomImage('food'))
        .toList());
  }

  Future<List<CategoryWithFoods>> getCategoriesWithFoods() {
    List<CategoryWithFoods> list = [];

    mockCategories.forEach((cat) {
      CategoryWithFoods catWithFood = CategoryWithFoods.fromCategory(cat);
      catWithFood.imageUrl = getRandomImage('header');
      list.add(catWithFood);
    });

    mockFoods.forEach((food) {
      food.imageUrl = getRandomImage('food');
      list.firstWhere((cat) => (food.categoryId == cat.id)).foods.add(food);
    });

    return Future.delayed(Duration(seconds: 4)).then((r) => list);
  }
}

String catDesc = 'this is a mock destipction for items.';
List<Category> mockCategories = [
  Category(id: '1', title: 'sushi', description: catDesc),
  Category(id: '2', title: 'special rullar', description: catDesc),
  Category(id: '3', title: 'sashimi', description: catDesc),
  Category(id: '4', title: 'hiku special', description: catDesc),
  Category(id: '5', title: 'sushibuffe', description: catDesc),
];

String foodDesc = catDesc;
List<Food> mockFoods = [
  Food(
      id: '1',
      categoryId: '1',
      title: 'sushi haiku',
      subTitle: 'kockens val',
      description: foodDesc,
      price: 25.0),
  Food(
      id: '2',
      categoryId: '1',
      title: 'pettit',
      subTitle: '6 bitar',
      description: foodDesc,
      price: 25.0),
  Food(
      id: '3',
      categoryId: '1',
      title: 'liten',
      subTitle: '8 bitar',
      description: foodDesc,
      price: 25.0),
  Food(
      id: '4',
      categoryId: '1',
      title: 'mellan',
      subTitle: '10 bitar',
      description: foodDesc,
      price: 25.0),
  Food(
      id: '5',
      categoryId: '1',
      title: 'stor',
      subTitle: '12 bitar',
      description: foodDesc,
      price: 25.0),
  Food(
      id: '6',
      categoryId: '1',
      title: 'x-store',
      subTitle: '14 bitar',
      description: foodDesc,
      price: 25.0),
  Food(
      id: '7',
      categoryId: '1',
      title: 'x-store',
      subTitle: '14 bitar',
      description: foodDesc,
      price: 25.0),
  Food(
      id: '8',
      categoryId: '2',
      title: 'tempura',
      subTitle: '8 bitar',
      description: foodDesc,
      price: 25.0),
  Food(
      id: '9',
      categoryId: '2',
      title: 'tanfisk rulle',
      subTitle: '8 bitar',
      description: foodDesc,
      price: 25.0),
  Food(
      id: '10',
      categoryId: '2',
      title: 'california lyx',
      subTitle: '8 bitar',
      description: foodDesc,
      price: 25.0),
  Food(
      id: '11',
      categoryId: '2',
      title: 'spicy dragon',
      subTitle: '8 bitar',
      description: foodDesc,
      price: 25.0),
  Food(
      id: '12',
      categoryId: '2',
      title: 'rainbow rulle',
      subTitle: '8 bitar',
      description: foodDesc,
      price: 25.0),
  Food(
      id: '13',
      categoryId: '3',
      title: 'sashimi shake',
      subTitle: '7 bitar',
      description: foodDesc,
      price: 25.0),
  Food(
      id: '14',
      categoryId: '3',
      title: 'tokyo style',
      subTitle: '11 bitar',
      description: foodDesc,
      price: 25.0),
  Food(
      id: '15',
      categoryId: '4',
      title: 'husets basta urval av',
      subTitle: 'sushi & sashini',
      description: foodDesc,
      price: 25.0),
  Food(
      id: '16',
      categoryId: '4',
      title: 'kombinerad med spicy dragon rulle',
      subTitle: '',
      description: foodDesc,
      price: 25.0),
];

List<String> imageUrls = [
  'assets/mock_images/food01.jpg',
  'assets/mock_images/food02.png',
  'assets/mock_images/food03.png',
  'assets/mock_images/food04.png',
  'assets/mock_images/header01.jpg',
  'assets/mock_images/header02.jpg',
  'assets/mock_images/header03.jpg',
];

String getRandomImage(String type) {
  List<String> urls = imageUrls.where((url) => (url.contains(type))).toList();
  int randomIndex = Random().nextInt(urls.length - 1);
  return urls[randomIndex];
}
