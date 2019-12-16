import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/widgets/widgets.dart';
import 'package:Food_Bar/bloc/bloc.dart';
import 'package:Food_Bar/utilities/text_util.dart';

class SingleCategory extends StatelessWidget {
  
  MenuBloc bloc;
  Category category;

  @override
  Widget build(BuildContext context) {
    category = ModalRoute.of(context).settings.arguments;
    bloc = BlocProvider.of<MenuBloc>(context);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (headerContext, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                floating: true,
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    TextUtil.toUperCaseForLable(category.title),
                    style: TextStyle(fontWeight: FontWeight.bold),),
                  background: Hero(
                    tag: category.id,
                    child: Image.asset(category.imageUrl, fit: BoxFit.cover),
                  ),
                ))
          ];
        },
        body: BlocBuilder(
          bloc: bloc,
          condition: (previousState, state) {
            return (state is InitialMenuState || state is ShowFoodsMenuState) ? true : false;
          },
          builder: (context, MenuState state) {

            if(state is InitialMenuState){
              askFoodList();
              return Center(child: CircularProgressIndicator(),);
            } else{
              ShowFoodsMenuState stateDetail = state;
              return buildFoodList(stateDetail.list);
            }

          },
        ),
      ),
    );
  }

  void askFoodList() {
    bloc.add(GetFoodsMenuEvent(category.id));
  }

  Widget buildFoodList(List<Food> foods) {
    return ListView.builder(
      itemCount: foods.length,
      padding: EdgeInsets.all(15),
      itemBuilder: (itemContext, int i) {
        Food food = foods[i];
        return Column(
          children: <Widget>[
            FoodCard(food),
            Divider(height: 0,)
          ],
        );
      },
    );
  }
}
