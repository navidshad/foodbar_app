import 'dart:async';

import 'package:foodbar_user/bloc/intro_bloc.dart';
import 'package:foodbar_user/settings/app_properties.dart';
import 'package:foodbar_flutter_core/settings/types.dart';
import 'package:foodbar_user/settings/types.dart';
import 'package:flutter/material.dart';

import 'package:foodbar_user/screens/screens.dart';
import 'package:foodbar_user/bloc/bloc.dart';

class Intro extends StatefulWidget {
  Intro({Key key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> with TickerProviderStateMixin {
  TabController _tabController;
  IntroBloc bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<IntroBloc>(context);
    bloc.authService.loginEvent.listen((key) {
      if (_tabController.index == 0) enterToHome(key);
    });
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: AppProperties.backLightColor,
      body: StreamBuilder(
        initialData: bloc.getInitialState(),
        stream: bloc.stateStream,
        builder: (context, snapshot) {
          IntroState state = snapshot.data;
          IntroTabType pageType = state.type;

          if (IntroBloc.forceTab != null) {
            pageType = IntroBloc.forceTab;
            IntroBloc.forceTab = null;
          }

          _tabController.index = _getTabIndexFromType(pageType);

          // go to next tabs affter seconds
          if (pageType == IntroTabType.Splash) _checkFirstEnterAndLoginStatus();

          return TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              SplashScreen(),
              SliderIntroTab(onDone: affterSlidesDone),
              LoginFormTab(),
              RegisterTab(),
            ],
          );
        },
      ),
    );
  }

  int _getTabIndexFromType(IntroTabType type) {
    switch (type) {
      case IntroTabType.Splash:
        return 0;
        break;
      case IntroTabType.Slider:
        return 1;
        break;
      case IntroTabType.LoginForm:
        return 2;
        break;
      case IntroTabType.RegisterForm:
        return 3;
        break;
      default:
        return 0;
    }
  }

  void _checkFirstEnterAndLoginStatus() async {
    await Future.delayed(Duration(seconds: AppProperties.splashDelayInSeconds));

    // check first enter to app
    bool firstEnter = false;

    // login with last session or as annymouse
    await bloc
        .loginWithLastSessionOrAnonymouse()
        .then((_) => firstEnter = bloc.authService.isFirstEnter);

    if (!firstEnter && !bloc.authService.isLogedInAsUser) {
      IntroEvent event;
      event = IntroSwitchEvent(switchTo: IntroTabType.Slider);
      bloc.eventSink.add(event);
    } else {
      enterToHome(true);
    }
  }

  void affterSlidesDone() {
    // IntroEvent event;
    // event = IntroSwitchEvent(switchTo: IntroTabType.LoginForm);

    // bloc.eventSink.add(event);
    enterToHome(true);
  }

  void enterToHome(bool allowToEnter) {
    if (!allowToEnter) return;

    Navigator.pushReplacementNamed(context, '/home');
  }
}
