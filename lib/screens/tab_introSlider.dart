import 'package:Food_Bar/bloc/intro_bloc.dart';
import 'package:Food_Bar/settings/settings.dart';
import 'package:flutter/material.dart';

import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

import 'package:Food_Bar/bloc/bloc.dart';

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
        backgroundColor: AppProperties.mainColor,
        styleTitle: TextStyle(
          color: AppProperties.textOnMainColor
        )
      );
      slides.add(slideObject);
    });

    return IntroSlider(
      slides: slides,
      onDonePress: onDone,
      onSkipPress: onDone,
      isShowSkipBtn: false,
      isShowPrevBtn: false,
    );
  }
}
