import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:meta/meta.dart';

import 'package:foodbar_flutter_core/interfaces/bloc_interface.dart';
import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_flutter_core/settings/types.dart';
import 'package:foodbar_flutter_core/services/services.dart';
import 'package:foodbar_flutter_core/interfaces/content_provider.dart';

class MenuEvent {
  MenuType type;

  MenuEvent(this.type);
}

class MenuState {
  bool isInitState;
  MenuType type;
  List<Category> categories;
  List<CategoryWithFoods> categoriesWithFoods;

  MenuState(
      {this.isInitState = false,
      @required this.type,
      this.categories = const [],
      this.categoriesWithFoods = const []});
}

class MenuBloc implements BlocInterface<MenuEvent, MenuState> {
  final _eventController = BehaviorSubject<MenuEvent>();
  final _stateController = BehaviorSubject<MenuState>();

  final ContentProvider _contentProvider = ContentService.instance;

  @override
  StreamSink<MenuEvent> get eventSink => _eventController.sink;

  @override
  Stream<MenuState> get stateStream => _stateController.stream;

  MenuBloc() {
    _eventController.stream.listen(handler);
  }

  void handler(MenuEvent event) async {
    MenuState state;

    if (event.type == MenuType.OnePage) {
      state = MenuState(
        type: event.type,
        categoriesWithFoods: await _contentProvider.getCategoriesWithFoods(),
      );
    } else {
      if (_contentProvider.categories?.length == 0)
        await _contentProvider.updateCategories();

      state = MenuState(
        type: event.type,
        categories: _contentProvider.categories,
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
