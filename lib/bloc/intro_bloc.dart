import 'dart:async';

import 'package:Food_Bar/interfaces/auth_interface.dart';
import 'package:Food_Bar/interfaces/bloc_interface.dart';
import 'package:Food_Bar/models/intro_slide_item.dart';
import 'package:Food_Bar/services/auth_service.dart';
import 'package:Food_Bar/services/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:Food_Bar/settings/types.dart';

class IntroBloc implements BlocInterface<IntroEvent, IntroState> {
  final MongoDBService mongodb = MongoDBService();
  final AuthInterface authService = AuthService.instant;

  final StreamController<IntroEvent> _eventController = BehaviorSubject();
  StreamSink<IntroEvent> get eventSink => _eventController.sink;

  final StreamController<IntroState> _stateController = BehaviorSubject();
  Stream<IntroState> get stateStream => _stateController.stream;

  List<IntroSlideItem> introSlideItems = [];

  IntroBloc() {
    _eventController.stream.listen(handler);
  }

  @override
  void dispose() {
    _eventController.close();
    _stateController.close();
  }

  @override
  IntroState getInitialState() {
    return IntroState(type: IntroTabType.Splash);
  }

  @override
  void handler(IntroEvent event) async {
    IntroState state = IntroState(type: event.switchTo);

    // check that is ther any Auth token
    // get a token if dosent exist
    if(!authService.isLogedIn) {
      await authService.loginAnonymous();
    }

    // get intro slides
    if (event.switchTo == IntroTabType.Slider) {
      await mongodb
          .find(database: 'cms', collection: 'introSlider')
          .then((list) {
        List slideDetail = list;
        slideDetail.forEach((itemDetail) {
          IntroSlideItem slide = IntroSlideItem.fromMap(itemDetail);
          introSlideItems.add(slide);
        });
      });
    }

    _stateController.add(state);
  }
}

class IntroEvent {
  IntroTabType switchTo;

  IntroEvent({this.switchTo});
}

class IntroState {
  IntroTabType type;

  IntroState({this.type});
}
