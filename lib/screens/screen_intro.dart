import 'package:foodbar_user/bloc/intro_bloc.dart';
import 'package:foodbar_user/settings/app_properties.dart';
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
    bloc.authService.loginEvent.listen(onLogedIn);
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppProperties.backLightColor,
      body: StreamBuilder(
        initialData: bloc.getInitialState(),
        stream: bloc.stateStream,
        builder: (context, snapshot) {
          IntroState state = snapshot.data;
          _tabController.index = _getTabIndexFromType(state.type);

          // go to next tabs affter seconds
          if (state.type == IntroTabType.Splash)
            _checkFirstEnterAndLoginStatus();

          return TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              SplashScreen(),
              SliderIntroTab(onDone: goToLoginForm),
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

    if (!firstEnter) {
      IntroEvent event;
      event = IntroSwitchEvent(switchTo: IntroTabType.Slider);
      bloc.eventSink.add(event);
    } else {
      goToLoginForm();
    }
  }

  Function goToLoginForm() {
    IntroEvent event;
    event = IntroSwitchEvent(switchTo: IntroTabType.LoginForm);

    bloc.eventSink.add(event);
  }

  void onLogedIn(bool isLogedIn) {
    if(!isLogedIn) return;

    if(bloc.authService.user.type == UserType.user)
      Navigator.pushReplacementNamed(context, '/home');
  }
}
