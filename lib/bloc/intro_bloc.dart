import 'dart:async';

import 'package:foodbar_flutter_core/interfaces/interfaces.dart';
import 'package:foodbar_flutter_core/models/intro_slide_item.dart';
import 'package:foodbar_user/services/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:foodbar_user/settings/types.dart';

class IntroBloc implements BlocInterface<IntroEvent, IntroState> {
  final MongoDBService mongodb = MongoDBService.instance;
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

  @override
  void handler(IntroEvent event) async {
    IntroState state;

    // check that is ther any Auth token
    if (!authService.isLogedIn) {
      await authService.loginWithLastSession().catchError((e) {
        print('loginWithLastSession has not been done.');
      });
    }
    
    // get a token if dosent exist
    if (!authService.isLogedIn) {
      await authService.loginAnonymous().catchError((e) {
        print('loginAnonymous has not been done.');
        print(e.toString());
      });
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
        print(error.toString());
        state = IntroLoginState(
          isSuccess: false,
          message: error,
          type: IntroTabType.LoginForm,
        );
      });
    }

    // wating on registration steps
    else if (event is IntroRegisterWaitingEvent) {
      state = IntroRegisterWaitingState(
        type: IntroTabType.RegisterForm,
      );
    }

    // submit id
    else if (event is IntroRegisterSubmitIdEvent) {
      await authService
          .registerSubmitId(
        identityType: 'email',
        identity: event.email,
      )
          .then((r) {
        state = IntroRegisterSubmitVarificationState(
          isSuccess: true,
          type: IntroTabType.RegisterForm,
        );
      }).catchError((error) {
        print(error.toString());
        state = IntroRegisterSubmitIdState(
          isSuccess: false,
          message: error.toString(),
          type: IntroTabType.RegisterForm,
        );
      });
    }

    // varify id
    else if (event is IntroRegisterVarifyIdEvent) {
      await authService.validateCode(code: event.code, id: event.id).then((r) {
        state = IntroRegisterSubmitPasswordState(
          isSuccess: true,
          type: IntroTabType.RegisterForm,
        );
      }).catchError((error) {
        print(error.toString());
        state = IntroRegisterSubmitVarificationState(
          isSuccess: false,
          message: error.toString(),
          type: IntroTabType.RegisterForm,
        );
      });
    }

    // submit password
    else if (event is IntroRegisterSubmitPasswordEvent) {
      await authService
          .registerSubmitPass(
        serial: event.code,
        identity: event.id,
        password: event.password,
      )
          .then((r) {
        state = IntroRegisterSuccessState(
          type: IntroTabType.RegisterForm,
        );
      }).catchError((error) {
        print(error.toString());
        state = IntroRegisterSubmitPasswordState(
          isSuccess: false,
          message: error.toString(),
          type: IntroTabType.RegisterForm,
        );
      });
    }

    // submit password
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
  String id;
  IntroRegisterVarifyIdEvent({this.code, this.id});
}

class IntroRegisterSubmitPasswordEvent extends IntroEvent {
  String password;
  String id;
  int code;
  IntroRegisterSubmitPasswordEvent({this.password, this.id, this.code});
}

class IntroRegisterWaitingEvent extends IntroEvent {}

class IntroState {
  IntroTabType type;
  IntroState({this.type});
}

class IntroLoginState extends IntroState {
  bool isSuccess;
  String message;

  IntroLoginState(
      {this.isSuccess = false, this.message = '', IntroTabType type})
      : super(type: type);
}

class IntroRegisterSubmitIdState extends IntroState {
  bool isSuccess;
  String message;

  IntroRegisterSubmitIdState(
      {this.isSuccess = false, this.message = '', IntroTabType type})
      : super(type: type);
}

class IntroRegisterSubmitVarificationState extends IntroState {
  bool isSuccess;
  String message;

  IntroRegisterSubmitVarificationState(
      {this.isSuccess = false, this.message = '', IntroTabType type})
      : super(type: type);
}

class IntroRegisterSubmitPasswordState extends IntroState {
  bool isSuccess;
  String message;

  IntroRegisterSubmitPasswordState(
      {this.isSuccess = false, this.message = '', IntroTabType type})
      : super(type: type);
}

class IntroRegisterSuccessState extends IntroState {
  IntroRegisterSuccessState({IntroTabType type}) : super(type: type);
}

class IntroRegisterWaitingState extends IntroState {
  IntroRegisterWaitingState({IntroTabType type}) : super(type: type);
}
