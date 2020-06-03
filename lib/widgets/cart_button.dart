import 'package:foodbar_user/settings/settings.dart';
import 'package:flutter/material.dart';

import 'package:foodbar_user/bloc/bloc.dart';
import 'package:foodbar_user/helpers/auth_alert.dart';

class CartButton extends StatefulWidget {
  final Function onTap;
  final Color color;
  final double size;

  CartButton({this.onTap, this.color, this.size = 25});

  @override
  _CartButtonState createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  CartBloc bloc;
  AppFrameBloc frameBloc;
  BuildContext _context;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<CartBloc>(context);
    frameBloc = BlocProvider.of<AppFrameBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

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
          size: widget.size,
        );

        // create counter
        double counterSize = (widget.size / 100) * 65;
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
            child: stack,
          ),
          onPressed: onPressed,
        );
      },
    );
  }

  void onPressed() {
    if (bloc.authService.isLogedInAsUser)
      goToCartPage();
    else {
      openAuthAlert(_context);
    }
  }

  void goToCartPage() {
    if (widget.onTap != null)
      widget.onTap();
    else {
      Navigator.popUntil(context, (route) => (route.settings.name == '/home'));
      frameBloc.eventSink.add(AppFrameEvent(switchFrom: FrameTabType.MENU));
    }
  }
}
