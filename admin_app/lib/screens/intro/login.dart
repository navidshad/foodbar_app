import 'package:foodbar_admin/bloc/intro_bloc.dart';
import 'package:foodbar_admin/services/options_service.dart';
import 'package:flutter/material.dart';

import 'package:foodbar_flutter_core/widgets/widgets.dart';
import 'package:foodbar_admin/utilities/food_bar_icons.dart';
// import 'package:foodbar_admin/bloc/bloc.dart';
import 'package:foodbar_admin/settings/types.dart';
import 'package:mrest_flutter/mrest_flutter.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  OptionsService options = OptionsService.instance;
  AuthService authService = AuthService();
  BuildContext _context;

  String _email = '';
  String _password = '';
  bool pending = false;

  String errorMessage = '';

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   bloc = BlocProvider.of<IntroBloc>(context);
  //   bloc.stateStream.listen(onGetState);
  // }

  @override
  Widget build(BuildContext context) {
    _context = context;

    // load logo and setup it
    Widget logo = Container(
      padding: EdgeInsets.only(top: 60, bottom: 40),
      child: Image.asset(
        options.properties.imgPathLogoWide,
        height: 120,
      ),
    );

    return Scaffold(
      body: ListView(
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
              style: TextStyle(color: Colors.red),
            ),
          ),

          CardButton(
            title: 'Login',
            height: 43,
            margin: EdgeInsets.only(top: 50),
            onTap: login,
            loading: pending,
            disabledColor: AppProperties.disabledColor,
            mainColor: AppProperties.mainColor,
            textOnDisabled: AppProperties.textOnDisabled,
            textOnMainColor: AppProperties.textOnMainColor,
            elevation: AppProperties.cardElevation,
          ),
          CardButton(
            title: 'Register',
            isOutline: true,
            height: 43,
            margin: EdgeInsets.only(top: 8),
            onTap: goToRegisterForm,
            disabledColor: AppProperties.disabledColor,
            mainColor: AppProperties.mainColor,
            textOnDisabled: AppProperties.textOnDisabled,
            textOnMainColor: AppProperties.textOnMainColor,
            elevation: AppProperties.cardElevation,
          ),
        ],
      ),
    );
  }

  void goToRegisterForm() {
    Navigator.of(_context).pushNamed('/register');
  }

  void login() {
    setState(() {
      pending = true;
    });

    authService
        .login(idType: IDType.email, id: _email, password: _password)
        .then((value) {
      print(value.email);
    }).catchError((onError) {
      print(onError);
    }).whenComplete(() {
      setState(() {
        pending = false;
      });
    });

    // IntroEvent event = IntroLoginEvent(email: _email, passwod: _password);
    // bloc.eventSink.add(event);
  }

  void onGetState(IntroState state) {
    if (state is IntroLoginState && !state.isSuccess)
      errorMessage = state.message;
  }
}
