import 'package:meta/meta.dart';

import 'package:Food_Bar/models/models.dart';

@immutable
abstract class MenuState {}
  
class InitialMenuState extends MenuState {}

class ShowOnePageMenuMenuState extends MenuState {
  final List<CategoryWithFoods> list;
  ShowOnePageMenuMenuState(this.list);
}

class ShowCategoriesMenuState extends MenuState {
  final List<Category> list;
  ShowCategoriesMenuState(this.list);
}

class ShowFoodsMenuState extends MenuState {
  final List<Food> list;
  ShowFoodsMenuState(this.list);
}
