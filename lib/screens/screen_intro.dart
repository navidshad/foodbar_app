import 'package:Food_Bar/bloc/intro_bloc.dart';
import 'package:Food_Bar/settings/app_properties.dart';
import 'package:Food_Bar/settings/types.dart';
import 'package:flutter/material.dart';

import 'package:Food_Bar/screens/screens.dart';
import 'package:Food_Bar/bloc/bloc.dart';

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
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        initialData: bloc.getInitialState(),
        stream: bloc.stateStream,
        builder: (context, snapshot) {
          IntroState state = snapshot.data;
          _tabController.index = _getTabIndexFromType(state.type);

          // go to next tabs affter seconds
          if (state.type == IntroTabType.Splash) _goToNextTab();

          return TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              SplashScreen(),
              SliderIntroTab(),
              LoginFormTab(),
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
      default:
        return 0;
    }
  }

  void _goToNextTab() async {
    await Future.delayed(Duration(seconds: AppProperties.splashDelayInSeconds));

    // check first enter to app
    bool firstEnter = false;

    IntroEvent event;
    if (firstEnter)
      event = IntroEvent(switchTo: IntroTabType.LoginForm);
    else
      event = IntroEvent(switchTo: IntroTabType.Slider);

    bloc.eventSink.add(event);
  }
}
