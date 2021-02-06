import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_user/widgets/widgets.dart';
import 'package:foodbar_user/bloc/bloc.dart';
import 'package:foodbar_user/settings/app_properties.dart';

class SingleCategory extends StatelessWidget {
  CategoryBloc bloc;
  Category category;

  @override
  Widget build(BuildContext context) {
    category = ModalRoute.of(context).settings.arguments;
    bloc = BlocProvider.of<CategoryBloc>(context);

    return Scaffold(
      body: PageWithScalableHeader(
        heroTag: category.getCombinedTag(),
        headerTitle: category.title,
        headerDescription: category.description,
        headerColor: Colors.blueAccent,
        headerBackImageUrl: category.image.getUrl(),
        rightSideBorder: false,
        borderRaduis: 60,
        bodyColor: Theme.of(context).backgroundColor,
        actionButtons: <Widget>[
          CartButton(color: Colors.white),
        ],
        body: StreamBuilder<CategoryState>(
          stream: bloc.stateStream,
          initialData: bloc.getInitialState(),
          builder: (context, AsyncSnapshot snapshot) {
            CategoryState state = snapshot.data;

            if (state.isInitial) {
              askFoodList();
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return buildFoodList(state.foods);
            }
          },
        ),
      ),
      // body: NestedScrollView(
      //   headerSliverBuilder: (headerContext, bool innerBoxIsScrolled) {
      //     return <Widget>[
      //       CustomSilverappBar(
      //         title: category.title,
      //         heroTag: category.getCombinedTag(),
      //         backGroundImage: category.image.getUrl(),
      //       )
      //     ];
      //   },
      //   body: StreamBuilder<CategoryState>(
      //     stream: bloc.stateStream,
      //     initialData: bloc.getInitialState(),
      //     builder: (context, AsyncSnapshot snapshot) {
      //       CategoryState state = snapshot.data;

      //       if (state.isInitial) {
      //         askFoodList();
      //         return Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       } else {
      //         return buildFoodList(state.foods);
      //       }
      //     },
      //   ),
      // ),
    );
  }

  void askFoodList() {
    bloc.eventSink.add(CategoryEvent(category.id));
  }

  Widget buildFoodList(List<Food> foods) {
    List<Widget> cards = [];

    for (var i = 0; i < foods.length; i++) {
      var food = foods[i];
      cards.add(FoodCard(food));
    }

    Widget content;

    if (foods.length == 0) {
      content = Center(
        child: Text(
          'There isn\'t any food yet.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      content = ListView(
        padding: EdgeInsets.only(
            top: 40,
            bottom: AppProperties.cardSideMargin,
            left: AppProperties.cardSideMargin,
            right: AppProperties.cardSideMargin),
        children: cards,
      );
    }

    return content;
  }
}
