import 'package:flutter/material.dart';
import 'package:foodbar_user/bloc/intro_bloc.dart';
import 'package:foodbar_user/settings/settings.dart';
import 'package:foodbar_user/settings/types.dart';
import 'package:foodbar_user/widgets/widgets.dart';

class PopupAuthAlert extends StatelessWidget {
  const PopupAuthAlert({Key? key}) : super(key: key);

  final double width = 100;
  final double height = 200;

  void onAccept(BuildContext context) {
    IntroBloc.forceTab = IntroTabType.LoginForm;
    Navigator.pushReplacementNamed(context, '/intro');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (con, constraints) {
      double tempWidth = (constraints.maxWidth > width)
          ? width
          : (constraints.maxWidth / 100) * 60;
      double tempHeight = (constraints.maxHeight > height)
          ? height
          : (constraints.maxHeight / 100) * 40;

      double marginX = (constraints.maxWidth - tempWidth) / 4;
      double marginY = (constraints.maxHeight - tempHeight) / 4;

      return Material(
        color: Colors.transparent,
        child: Container(
            padding: EdgeInsets.only(
              top: marginY,
              bottom: marginY,
              left: marginX,
              right: marginX,
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  top: 50,
                  child: Card(
                    margin: EdgeInsets.all(0),
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // text
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: tempHeight,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    margin: EdgeInsets.only(top: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'You Are A Guest',
                          style: TextStyle(fontSize: AppProperties.h3),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          'To continue for working with the app, you have to login or create a new account.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: AppProperties.p),
                        )
                      ],
                    ),
                  ),
                ),

                // button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    width: 150,
                    height: 45,
                    child: StatusButton(
                      title: 'Login',
                      onTap: (completer) => onAccept(context),
                    ),
                  ),
                ),
              ],
            )),
      );
    });
  }
}
