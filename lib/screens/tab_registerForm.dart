import 'package:Food_Bar/bloc/intro_bloc.dart';
import 'package:flutter/material.dart';

import 'package:Food_Bar/settings/app_properties.dart';
import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/utilities/food_bar_icons.dart';
import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/settings/types.dart';

class RegisterTab extends StatelessWidget {
  RegisterTab({Key key}) : super(key: key);

  IntroBloc bloc;

  @override
  Widget build(BuildContext context) {

    bloc = BlocProvider.of<IntroBloc>(context);

    // load logo and setup it
    Widget logo = Container(
      padding: EdgeInsets.only(top:60, bottom: 40),
      child: Image.asset(
        AppProperties.imgPathLogoWide,
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
        ),
        TextfieldWithIcon(
          iconData: FoodBarIcons.password,
          hint: 'Password',
          obscureText: true,
        ),
        CardButton(
          title: 'Register',
          height: 43,
          margin: EdgeInsets.only(top: 50),
          onTap: () {},
        ),
        CardButton(
          title: 'Login',
          isOutline: true,
          height: 43,
          margin: EdgeInsets.only(top: 8),
          onTap: goToLoginForm,
        ),
      ],
    );
  }

  Function goToLoginForm() {
    IntroEvent event;
    event = IntroSwitchEvent(switchTo: IntroTabType.LoginForm);

    bloc.eventSink.add(event);
  }
}
