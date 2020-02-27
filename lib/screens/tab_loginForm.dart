import 'package:Food_Bar/bloc/intro_bloc.dart';
import 'package:Food_Bar/services/options_service.dart';
import 'package:flutter/material.dart';

import 'package:Food_Bar/settings/app_properties.dart';
import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/utilities/food_bar_icons.dart';
import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/settings/types.dart';
import 'package:Food_Bar/settings/app_properties.dart';


class LoginFormTab extends StatefulWidget {
  LoginFormTab({Key key}) : super(key: key);

  @override
  _LoginFormTabState createState() => _LoginFormTabState();
}

class _LoginFormTabState extends State<LoginFormTab> {

  OptionsService options = OptionsService.instance;

  IntroBloc bloc;
  String _email = '';
  String _password = '';

  String errorMessage = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<IntroBloc>(context);
    bloc.stateStream.listen(onGetState);
  }

  @override
  Widget build(BuildContext context) {
    // load logo and setup it
    Widget logo = Container(
      padding: EdgeInsets.only(top: 60, bottom: 40),
      child: Image.asset(
        options.properties.imgPathLogoWide,
        height: 120,
      ),
    );

    return ListView(
      padding: EdgeInsets.only(left: 30, right: 30),
      children: <Widget>[
        logo,
        TextfieldWithIcon(
          iconData: FoodBarIcons.email,
          hint: 'Email',
          onSubmitted: (value) => _email = value.trim(),
          keyboardType: TextInputType.emailAddress,
        ),
        TextfieldWithIcon(
          iconData: FoodBarIcons.password,
          hint: 'Password',
          obscureText: true,
          onSubmitted: (value) => _password = value.trim(),
        ),

        // error
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red
            ),
          ),
        ),

        CardButton(
          title: 'Login',
          height: 43,
          margin: EdgeInsets.only(top: 50),
          onTap: login,
        ),
        CardButton(
          title: 'Register',
          isOutline: true,
          height: 43,
          margin: EdgeInsets.only(top: 8),
          onTap: goToRegisterForm,
        ),
      ],
    );
  }

  void goToRegisterForm() {
    IntroEvent event;
    event = IntroSwitchEvent(switchTo: IntroTabType.RegisterForm);

    bloc.eventSink.add(event);
  }

  void login() {
    IntroEvent event = IntroLoginEvent(email: _email, passwod: _password);
    bloc.eventSink.add(event);
  }

  void onGetState(IntroState state) {
    if (state is IntroLoginState && !state.isSuccess)
      errorMessage = state.message;
  }
}
