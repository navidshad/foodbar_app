import 'package:meta/meta.dart';

@immutable
abstract class MenuEvent {}

class GetOnePageMenuMenuEvent extends MenuEvent {}

class GetCategoriesMenuEvent extends MenuEvent {}

class GetFoodsMenuEvent extends MenuEvent {
  final String categoryId;
  GetFoodsMenuEvent(this.categoryId);
}
