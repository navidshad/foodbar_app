import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:meta/meta.dart';

import 'package:Food_Bar/interfaces/bloc_interface.dart';
import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/settings/types.dart';
import 'package:Food_Bar/services/services.dart';
import 'package:Food_Bar/interfaces/content_provider.dart';

class MenuEvent {
  MenuType type;

  MenuEvent(this.type);
}

class MenuState {
  bool isInitState;
  MenuType type;
  List<Category> categories;
  List<CategoryWithFoods> categoriesWithFoods;

  MenuState({this.isInitState = false, @required this.type, this.categories, this.categoriesWithFoods});
}

class MenuBloc implements BlocInterface<MenuEvent, MenuState> {
  final _eventController = BehaviorSubject<MenuEvent>();
  final _stateController = BehaviorSubject<MenuState>();

  final ContentProvider _contentProvider = MockContentService();

  @override
  StreamSink<MenuEvent> get eventSink => _eventController.sink;

  @override
  Stream<MenuState> get stateStream => _stateController.stream;

  MenuBloc() {
    _eventController.stream.listen(_handler);
  }

  void _handler(MenuEvent event) async {
    MenuState state;

    if (event.type == MenuType.OnePage) {
      state = MenuState(
        type: event.type,
        categoriesWithFoods: await _contentProvider.getCategoriesWithFoods(),
      );
    } else {
      state = MenuState(
        type: event.type,
        categories: await _contentProvider.getCategories(),
      );
    }

    _stateController.add(state);
  }

  @override
  void dispose() {
    _eventController.close();
    _stateController.close();
  }

  @override
  MenuState getInitialState() {
    return MenuState(isInitState: true, type: null);
  }
}
