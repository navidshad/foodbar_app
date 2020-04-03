import 'package:foodbar_user/settings/settings.dart';
import 'package:flutter/material.dart';

import 'package:foodbar_user/bloc/bloc.dart';

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
        Icon icon = Icon(
          iconData,
          color: widget.color,
          size: AppProperties.appBarIconSize,
        );

        // create counter
        double counterSize = (AppProperties.appBarIconSize / 100) * 65;
        Widget counterWidget = Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: counterSize,
            height: counterSize,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                state.total.toString(),
                textAlign: TextAlign.center,
                textScaleFactor: 0.8,
                style: TextStyle(color: Theme.of(context).colorScheme.onError),
              ),
            ),
          ),
        );

        List<Widget> stackList = [icon];

        // add counter widget to stack list
        if (state.total > 0) stackList.add(counterWidget);

        Stack stack = Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: stackList,
        );

        return FlatButton(
          child: Container(
            height: AppProperties.appBarIconSize + counterSize,
            width: AppProperties.appBarIconSize + counterSize,
            child: stack,
          ),
          onPressed: widget.onTap ?? goToCartPage,
        );
      },
    );
  }

  void goToCartPage() {
    Navigator.popUntil(context, (route) => (route.settings.name == '/home'));
    frameBloc.eventSink.add(AppFrameEvent(switchFrom: FrameTabType.MENU));
  }
}
