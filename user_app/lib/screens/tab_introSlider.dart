import 'package:foodbar_user/bloc/intro_bloc.dart';
import 'package:foodbar_user/settings/settings.dart';
import 'package:flutter/material.dart';

import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

import 'package:foodbar_user/bloc/bloc.dart';

class SliderIntroTab extends StatelessWidget {
  Function onDone;
  BuildContext _context;

  SliderIntroTab({Key key, @required this.onDone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IntroBloc bloc = BlocProvider.of<IntroBloc>(context);
    _context = context;
    List<Slide> slides = [];

    bloc.introSlideItems.forEach((item) {
      Widget imageWidget;

      if (item.image.isAbsolute) {
        imageWidget = Container(
          margin: EdgeInsets.only(bottom: 50),
          child: Image.network(item.image.getUrl()),
        );
      }

      Slide slideObject = Slide(
          title: item.title,
          description: item.description,
          backgroundColor: Theme.of(context).colorScheme.background,
          marginDescription: EdgeInsets.only(left: 50, right: 50),
          styleTitle: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.bold,
              fontSize: 25),
          centerWidget: imageWidget,
          styleDescription: TextStyle(
              color: Theme.of(context).colorScheme.onBackground, fontSize: 18));
      slides.add(slideObject);
    });

    if (slides.length > 0) {
      return IntroSlider(
        slides: slides,
        onDonePress: onDone,
        onSkipPress: onDone,
        isShowSkipBtn: false,
        isShowPrevBtn: false,
        colorDoneBtn: Theme.of(context).colorScheme.secondaryVariant,
      );
    } else {
      enterToHome();
      return Container();
    }
  }

  void enterToHome() {
    Future.doWhile(() => !_context.findRenderObject().attached)
        .whenComplete(() => Navigator.pushReplacementNamed(_context, '/home'));
  }
}
