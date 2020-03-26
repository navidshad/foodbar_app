import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:foodbar_flutter_core/interfaces/bloc_interface.dart';
import 'package:foodbar_flutter_core/interfaces/content_provider.dart';
import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_flutter_core/services/services.dart';

class CategoryEvent {
  String id;
  CategoryEvent(this.id);
}

class CategoryState {
  bool isInitial;
  List<Food> foods;
  CategoryState({this.foods = const [], this.isInitial = false});
}

class CategoryBloc implements BlocInterface<CategoryEvent, CategoryState> {
  final _eventController = BehaviorSubject<CategoryEvent>();
  final _stateController = BehaviorSubject<CategoryState>();
  final ContentProvider _contentProvider = ContentService.instance;

  @override
  StreamSink<CategoryEvent> get eventSink => _eventController.sink;

  @override
  Stream<CategoryState> get stateStream => _stateController.stream;

  CategoryBloc() {
    _eventController.stream.listen(handler);
  }

  void handler(CategoryEvent event) async {
    List<Food> foods = await _contentProvider.getFoods(event.id);
    CategoryState state = CategoryState(foods: foods);

    _stateController.add(state);
  }

  @override
  getInitialState() {
    return CategoryState(isInitial: true);
  }

  @override
  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}
