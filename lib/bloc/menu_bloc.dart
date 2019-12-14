import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

import 'package:Food_Bar/services/services.dart';
import 'package:Food_Bar/models/models.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {

  ContentProvider contentProvider = MockContentService();

  @override
  MenuState get initialState => InitialMenuState();

  @override
  Stream<MenuState> mapEventToState(
    MenuEvent event,
  ) async* {
    
    if(event is GetOnePageMenuMenuEvent)
    {
      List<CategoryWithFoods> categoriesWithFoods = await contentProvider.getCategoriesWithFoods();
      yield ShowOnePageMenuMenuState(categoriesWithFoods);
    }

  }
}
