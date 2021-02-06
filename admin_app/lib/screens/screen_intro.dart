import 'package:foodbar_admin/bloc/intro_bloc.dart';
import 'package:foodbar_admin/settings/app_properties.dart';
import 'package:foodbar_admin/settings/types.dart';
import 'package:foodbar_flutter_core/settings/types.dart';
import 'package:flutter/material.dart';

import 'package:foodbar_admin/screens/screens.dart';
import 'package:foodbar_admin/bloc/bloc.dart';

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
    _tabController = TabController(length: 3, vsync: this);
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
          _tabController.index = state.type.index;

          // go to next tabs affter seconds
          if (state.type == IntroTabType.Splash)
            _checkFirstEnterAndLoginStatus();

          return TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              SplashScreen(),
              LoginFormTab(),
              RegisterTab(),
            ],
          );
        },
      ),
    );
  }

  void _checkFirstEnterAndLoginStatus() async {
    await Future.delayed(Duration(seconds: AppProperties.splashDelayInSeconds));

    // check first enter to app
    bool firstEnter = false;

    if (firstEnter) {
      
    } else {
      goToLoginForm();
    }
  }

  void goToLoginForm() {
    IntroEvent event;
    event = IntroSwitchEvent(switchTo: IntroTabType.LoginForm);

    bloc.eventSink.add(event);
  }

  void onLogedIn(bool isLogedIn) {
    if(!isLogedIn) return;

    if(bloc.authService.user.type.index == UserType.user.index)
      Navigator.pushReplacementNamed(context, '/home');
  }
}
