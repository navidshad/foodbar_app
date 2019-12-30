import 'package:flutter/material.dart';

class ReservationTab extends StatefulWidget {
  ReservationTab({Key key}) : super(key: key);

  @override
  _ReservationTabState createState() => _ReservationTabState();
}

class _ReservationTabState extends State<ReservationTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Reservation'),
    );
  }
}