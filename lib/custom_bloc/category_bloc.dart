import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:Food_Bar/interfaces/bloc_interface.dart';
import 'package:Food_Bar/interfaces/content_provider.dart';
import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/services/services.dart';

class CategoryEvent {
  String id;
  CategoryEvent(this.id);
}

class CategoryState {
  bool isInitial;
  List<Food> foods;
  CategoryState({this.foods, this.isInitial=false});
}

class CategoryBloc implements BlocInterface<CategoryEvent, CategoryState> {
  
  final _eventController = BehaviorSubject<CategoryEvent>();
  final _stateController = BehaviorSubject<CategoryState>();
  final ContentProvider _contentProvider = MockContentService();

  @override
  StreamSink<CategoryEvent> get eventSink => _eventController.sink;

  @override
  Stream<CategoryState> get stateStream => _stateController.stream;

  CategoryBloc() {
    _eventController.stream.listen(_handler);
  }

  void _handler(CategoryEvent event) async {
      CategoryState state = CategoryState(
        foods : await _contentProvider.getFoods(event.id)
      );
      
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