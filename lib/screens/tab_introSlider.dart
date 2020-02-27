import 'package:Foodbar_user/bloc/intro_bloc.dart';
import 'package:Foodbar_user/settings/settings.dart';
import 'package:flutter/material.dart';

import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

import 'package:Foodbar_user/bloc/bloc.dart';

class SliderIntroTab extends StatelessWidget {
  Function onDone;

  SliderIntroTab({Key key, @required this.onDone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IntroBloc bloc = BlocProvider.of<IntroBloc>(context);

    List<Slide> slides = [];

    bloc.introSlideItems.forEach((item) {
      Slide slideObject = Slide(
          title: item.title,
          description: item.description,
          backgroundColor: AppProperties.backLightColor,
          marginDescription: EdgeInsets.only(left: 50, right: 50),
          styleTitle: TextStyle(
            color: AppProperties.mainColor,
            fontWeight: FontWeight.bold,
            fontSize: 25
          ),
          styleDescription: TextStyle(
            color: AppProperties.textOnBackLight,
            fontSize: 18
          ));
      slides.add(slideObject);
    });

    return IntroSlider(
      slides: slides,
      onDonePress: onDone,
      onSkipPress: onDone,
      isShowSkipBtn: false,
      isShowPrevBtn: false,
      colorDoneBtn: AppProperties.mainColor,
    );
  }
}
