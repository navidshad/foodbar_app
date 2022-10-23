import 'package:foodbar_admin/bloc/intro_bloc.dart';
import 'package:flutter/material.dart';

import 'package:foodbar_flutter_core/widgets/widgets.dart';
import 'package:foodbar_admin/utilities/food_bar_icons.dart';
import 'package:foodbar_admin/bloc/bloc.dart';
import 'package:foodbar_admin/settings/types.dart';
import 'package:foodbar_admin/services/options_service.dart';

class RegisterTab extends StatefulWidget {
  RegisterTab({Key? key}) : super(key: key);

  @override
  _RegisterTabState createState() => _RegisterTabState();
}

class _RegisterTabState extends State<RegisterTab> {
  OptionsService options = OptionsService.instance;

  late IntroBloc bloc;
  String _email = '';
  String _password = '';
  late int _varificationCode;

  String errorMessage = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<IntroBloc>(context);
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

    return StreamBuilder<IntroState>(
      initialData: IntroRegisterSubmitIdState(isSuccess: true),
      stream: bloc.stateStream,
      builder: (con, snapshot) {
        errorMessage = '';
        List<Widget> listElements = [logo];

        IntroState state = snapshot.data as IntroState;

        if (state is IntroRegisterWaitingState)
          listElements.add(getWaitingWidget());
        else if (state is IntroRegisterSubmitIdState)
          listElements.insertAll(1, getIdForm(state));
        else if (state is IntroRegisterSubmitVarificationState)
          listElements.insertAll(1, getSubmitVarificationCodeForm(state));
        else if (state is IntroRegisterSubmitPasswordState)
          listElements.insertAll(1, getSubmitPasswordForm(state));
        else if (state is IntroRegisterSuccessState)
          listElements.insertAll(1, getSuccessForm());
        else
          listElements.insertAll(1, getIdForm(IntroRegisterSubmitIdState()));

        // show error
        if (errorMessage.length > 0) {
          Widget errorWidget = Container(
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
          );
          listElements.insert(1, errorWidget);
        }

        return ListView(
          padding: EdgeInsets.only(left: 30, right: 30),
          children: listElements,
        );
      },
    );
  }

  Widget getWaitingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  List<Widget> getIdForm([IntroRegisterSubmitIdState? state]) {
    if (state != null && state.isSuccess) errorMessage = state.message;

    return [
      TextfieldWithIcon(
        iconData: FoodBarIcons.email,
        hint: 'Email',
        onSubmitted: (value) => _email = value.trim(),
        keyboardType: TextInputType.emailAddress,
      ),
      CardButton(
        title: 'Submit Your Email',
        height: 43,
        margin: EdgeInsets.only(top: 50),
        onTap: submitId,
        disabledColor: AppProperties.disabledColor,
        mainColor: AppProperties.mainColor,
        textOnDisabled: AppProperties.textOnDisabled,
        textOnMainColor: AppProperties.textOnMainColor,
        elevation: AppProperties.cardElevation,
      ),
      CardButton(
        title: 'Login',
        isOutline: true,
        height: 43,
        margin: EdgeInsets.only(top: 8),
        onTap: goToLoginForm,
        disabledColor: AppProperties.disabledColor,
        mainColor: AppProperties.mainColor,
        textOnDisabled: AppProperties.textOnDisabled,
        textOnMainColor: AppProperties.textOnMainColor,
        elevation: AppProperties.cardElevation,
      ),
    ];
  }

  List<Widget> getSubmitVarificationCodeForm(
      IntroRegisterSubmitVarificationState state) {
    if (!state.isSuccess) errorMessage = state.message;

    return [
      TextfieldWithIcon(
        iconData: Icons.confirmation_number,
        hint: 'Code',
        keyboardType: TextInputType.number,
        onSubmitted: (value) {
          _varificationCode = int.tryParse(value)!;
        },
      ),
      CardButton(
        title: 'Submit',
        height: 43,
        margin: EdgeInsets.only(top: 50),
        onTap: submitVarificationCode,
        disabledColor: AppProperties.disabledColor,
        mainColor: AppProperties.mainColor,
        textOnDisabled: AppProperties.textOnDisabled,
        textOnMainColor: AppProperties.textOnMainColor,
        elevation: AppProperties.cardElevation,
      ),
      CardButton(
        title: 'Login',
        isOutline: true,
        height: 43,
        margin: EdgeInsets.only(top: 8),
        onTap: goToLoginForm,
        disabledColor: AppProperties.disabledColor,
        mainColor: AppProperties.mainColor,
        textOnDisabled: AppProperties.textOnDisabled,
        textOnMainColor: AppProperties.textOnMainColor,
        elevation: AppProperties.cardElevation,
      ),
    ];
  }

  List<Widget> getSubmitPasswordForm(IntroRegisterSubmitPasswordState state) {
    if (!state.isSuccess) errorMessage = state.message;

    return [
      TextfieldWithIcon(
        iconData: FoodBarIcons.password,
        hint: 'Password',
        obscureText: true,
        onSubmitted: (value) => _password = value.trim(),
      ),
      CardButton(
        title: 'Submit',
        height: 43,
        margin: EdgeInsets.only(top: 50),
        onTap: submitPassword,
        disabledColor: AppProperties.disabledColor,
        mainColor: AppProperties.mainColor,
        textOnDisabled: AppProperties.textOnDisabled,
        textOnMainColor: AppProperties.textOnMainColor,
        elevation: AppProperties.cardElevation,
      ),
      CardButton(
        title: 'Login',
        isOutline: true,
        height: 43,
        margin: EdgeInsets.only(top: 8),
        onTap: goToLoginForm,
        disabledColor: AppProperties.disabledColor,
        mainColor: AppProperties.mainColor,
        textOnDisabled: AppProperties.textOnDisabled,
        textOnMainColor: AppProperties.textOnMainColor,
        elevation: AppProperties.cardElevation,
      ),
    ];
  }

  List<Widget> getSuccessForm() {
    return [
      Container(
        margin: EdgeInsets.only(bottom: 50),
        child: Text(
          'Congratulation your account has been created. \nNow you can login to it.',
          style: TextStyle(
            fontSize: 18,
            color: Colors.green,
          ),
        ),
      ),
      CardButton(
        title: 'Login',
        isOutline: false,
        height: 43,
        margin: EdgeInsets.only(top: 8),
        onTap: goToLoginForm,
        disabledColor: AppProperties.disabledColor,
        mainColor: AppProperties.mainColor,
        textOnDisabled: AppProperties.textOnDisabled,
        textOnMainColor: AppProperties.textOnMainColor,
        elevation: AppProperties.cardElevation,
      ),
    ];
  }

  void goToLoginForm() {
    IntroEvent event;
    event = IntroSwitchEvent(switchTo: IntroTabType.LoginForm);

    bloc.eventSink.add(event);
  }

  Future<void> waite() {
    IntroEvent event = IntroRegisterWaitingEvent();
    bloc.eventSink.add(event);

    return Future.delayed(Duration(milliseconds: 500));
  }

  void submitId() async {
    await waite();
    IntroEvent event;
    event = IntroRegisterSubmitIdEvent(_email);
    bloc.eventSink.add(event);
  }

  void submitVarificationCode() async {
    await waite();
    IntroEvent event;
    event = IntroRegisterVarifyIdEvent(id: _email, code: _varificationCode);
    bloc.eventSink.add(event);
  }

  void submitPassword() async {
    await waite();
    IntroEvent event;
    event = IntroRegisterSubmitPasswordEvent(
      password: _password,
      id: _email,
      code: _varificationCode,
    );
    bloc.eventSink.add(event);
  }
}
