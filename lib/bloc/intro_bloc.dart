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
    //authService.loginEvent.listen(onLoginEvent);
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

  // void onLoginEvent(bool isLogedin) {
  //   IntroEvent state = IntroSwitchEvent(switchTo: IntroTabType.LoginForm);
  //   handler(state);
  // }

  @override
  void handler(IntroEvent event) async {
    IntroState state;

    // check that is ther any Auth token
    // get a token if dosent exist
    if (!authService.isLogedIn) {
      await authService.loginAnonymous();
    }

    // switch events
    if (event is IntroSwitchEvent) {
      state = IntroState(type: event.switchTo);

      // get intro slides
      if (event.switchTo == IntroTabType.Slider) {
        await mongodb
            .find(database: 'cms', collection: 'introSlider')
            .then((list) {
          List slideDetail = list;
          introSlideItems = [];
          slideDetail.forEach((itemDetail) {
            IntroSlideItem slide = IntroSlideItem.fromMap(itemDetail);
            introSlideItems.add(slide);
          });
        });
      }
    }

    // login event
    if (event is IntroLoginEvent) {
      await authService
          .login(
        identityType: 'email',
        identity: event.email,
        password: event.passwod,
      )
          .then((r) {
        state = IntroLoginState(
          isSuccess: true,
          type: IntroTabType.Splash,
        );
      }).catchError((error) {
        state = IntroLoginState(
          isSuccess: false,
          message: error,
          type: IntroTabType.LoginForm,
        );
      });
    }

    _stateController.add(state);
  }
}

class IntroEvent {}

class IntroSwitchEvent extends IntroEvent {
  IntroTabType switchTo;
  IntroSwitchEvent({this.switchTo});
}

class IntroLoginEvent extends IntroEvent {
  String email;
  String passwod;

  IntroLoginEvent({this.email, this.passwod});
}

class IntroRegisterSubmitIdEvent extends IntroEvent {
  String email;

  IntroRegisterSubmitIdEvent(this.email);
}

class IntroRegisterVarifyIdEvent extends IntroEvent {
  int code;
  IntroRegisterVarifyIdEvent(this.code);
}

class IntroRegisterSubmitPassword extends IntroEvent {
  String password;
  IntroRegisterSubmitPassword(this.password);
}

class IntroState {
  IntroTabType type;
  IntroState({this.type});
}

class IntroLoginState extends IntroState {
  bool isSuccess;
  String message;

  IntroLoginState({this.isSuccess, this.message, IntroTabType type})
      : super(type: type);
}

class IntroRegisterSubmitIdState extends IntroState {
  bool isSuccess;
  String message;

  IntroRegisterSubmitIdState({this.isSuccess, this.message, IntroTabType type})
      : super(type: type);
}

class IntroRegisterSubmitVarificationState extends IntroState {
  bool isSuccess;
  String message;

  IntroRegisterSubmitVarificationState(
      {this.isSuccess, this.message, IntroTabType type})
      : super(type: type);
}

class IntroRegisterSubmitPasswordState extends IntroState {
  bool isSuccess;
  String message;

  IntroRegisterSubmitPasswordState(
      {this.isSuccess, this.message, IntroTabType type})
      : super(type: type);
}
