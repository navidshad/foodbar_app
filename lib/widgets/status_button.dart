import 'dart:async';

import 'package:flutter/material.dart';

class StatusButton extends StatefulWidget {
  const StatusButton({
    Key key,
    this.title,
    this.onTap,
    this.isActive,
    this.width,
    this.margine,
  }) : super(key: key);

  final String title;
  final Function(Completer completer) onTap;
  final bool isActive;
  final double width;
  final EdgeInsetsGeometry margine;

  @override
  _StatusButtonState createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  bool isPending = false;
  Completer completer;

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isPending)
      content = Center(
        child: Theme(
          data: ThemeData(
            accentColor: Theme.of(context).colorScheme.onPrimary
          ),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        ),
      );
    else {
      content = Text(
        widget.title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 13,
          // fontWeight: FontWeight.bold,
        ),
      );
    }

    List<Color> colors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.primaryVariant
    ];

    if (!widget.isActive == true) {
      colors = [
        Theme.of(context).disabledColor,
        Theme.of(context).disabledColor,
      ];
    }

    return AbsorbPointer(
      absorbing: !widget.isActive,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: widget.width ?? double.infinity,
          height: 60,
          margin: widget.margine,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
            ),
          ),
          child: Center(
            child: content,
          ),
        ),
      ),
    );
  }

  void onTap() async {
    completer = Completer();
    isPending = true;
    setState(() {});

    await Future.delayed(Duration(milliseconds: 500));

    completer.future.whenComplete(() {
      isPending = false;
      setState(() {});
    });

    widget.onTap(completer);
  }
}
