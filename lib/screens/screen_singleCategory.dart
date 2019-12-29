import 'package:flutter/material.dart';

import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/utilities/text_util.dart';
import 'package:Food_Bar/settings/app_properties.dart';

class SingleCategory extends StatelessWidget {
  CategoryBloc bloc;
  Category category;

  @override
  Widget build(BuildContext context) {
    category = ModalRoute.of(context).settings.arguments;
    bloc = BlocProvider.of<CategoryBloc>(context);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (headerContext, bool innerBoxIsScrolled) {
          return <Widget>[
            CustomSilverappBar(
              title: category.title,
              heroTag: category.getCombinedTag(),
              backGroundImage: category.imageUrl,
            )
          ];
        },
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
    );
  }

  void askFoodList() {
    bloc.eventSink.add(CategoryEvent(category.id));
  }

  Widget buildFoodList(List<Food> foods) {
    return ListView.builder(
      itemCount: foods.length,
      padding: EdgeInsets.all(AppProperties.cardSideMargin),
      itemBuilder: (itemContext, int i) {
        Food food = foods[i];
        return Column(
          children: <Widget>[
            FoodCard(food),
            //Divider(height: 0,)
          ],
        );
      },
    );
  }
}
