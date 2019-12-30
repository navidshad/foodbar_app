import 'package:Food_Bar/settings/settings.dart';
import 'package:flutter/material.dart';

import 'package:Food_Bar/bloc/bloc.dart';

class CartButton extends StatefulWidget {
  final Function onTap;
  final Color color;

  CartButton({this.onTap, this.color});

  @override
  _CartButtonState createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  CartBloc bloc;
  AppFrameBloc frameBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<CartBloc>(context);
    frameBloc = BlocProvider.of<AppFrameBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CartCounterState>(
      stream: bloc.stateCounter,
      initialData: bloc.getInitialCounterState(),
      builder: (context, snapshot) {
        CartCounterState state = snapshot.data;

        // create IconData
        IconData iconData;
        if (state.total > 0)
          iconData = AppProperties.cartIcon;
        else
          iconData = AppProperties.cartIconEmpty;

        // creat button
        Icon icon = Icon(iconData, color: widget.color,);

        // create counter
        Widget counterWidget = Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
              color: AppProperties.mainColor, shape: BoxShape.circle),
          child: Center(
            child: Text(
              state.total.toString(),
              textAlign: TextAlign.center,
              textScaleFactor: 0.8,
              style: TextStyle(color: AppProperties.textOnMainColor),
            ),
          ),
        );

        List<Widget> stackList = [icon];

        // add counter widget to stack list
        if(state.total > 0) stackList.add(counterWidget);

        Stack stack = Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: stackList,
        );

        return FlatButton(
          child: stack,
          onPressed: widget.onTap ?? goToCartPage,
        );
      },
    );
  }

  void goToCartPage () {
    Navigator.popUntil(context, (route) => (route.settings.name == '/home'));
    frameBloc.eventSink.add(AppFrameEvent(switchFrom: FrameTabType.MENU));
  }
}
