import 'package:flutter/material.dart';
import 'package:foodbar_flutter_core/models/person_picker_options.dart';
import 'package:foodbar_user/bloc/bloc.dart';
import 'package:foodbar_user/widgets/widgets.dart';

class PersonSelector extends StatefulWidget {
  PersonSelector({Key key, @required this.bloc, @required this.onSelectPerson})
      : super(key: key);

  final ReservationBloc bloc;
  final Function(int persons) onSelectPerson;

  @override
  _PersonSelectorState createState() => _PersonSelectorState();
}

class _PersonSelectorState extends State<PersonSelector> {
  PersonPickerOptions options;

  @override
  void initState() {
    widget.bloc.personStream.listen((op) {
      options = op;

      if (this.mounted) setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    double sidePadding = 30;
    double cardSpace = 20;
    Widget personSlider;

    if (options == null) {
      widget.bloc.eventSink.add(GetTotalPerson());
      personSlider = Center(
        child: CircularProgressIndicator(),
      );
    } else if (options.divisions == 0) {
      personSlider = Text(
        'this time has been reserved'.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
          color: Theme.of(context).colorScheme.error,
        ),
      );
    } else {
      personSlider = CustomIntSlider(
        title: 'Total Person',
        divisions: options.divisions,
        min: options.min,
        max: options.max,
        onChanged: (value) {
          ReservationBloc.selectedPersons = value;
          widget.onSelectPerson(value);
        },
      );
    }

    return Container(
        padding: EdgeInsets.only(left: sidePadding, right: sidePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Container(
            //   width: totalWidth - (sidePadding * 2),
            //   height: totalHeight / 100 * 35,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.all(Radius.circular(15)),
            //       shape: BoxShape.rectangle,
            //       image: DecorationImage(
            //           image: NetworkImage(
            //               widget.ReservationBloc.selectedTable.image.getUrl()),
            //           fit: BoxFit.cover,
            //           colorFilter: ColorFilter.mode(
            //             Theme.of(context).disabledColor,
            //             BlendMode.darken,
            //           ))),
            //   child: FittedBox(
            //     child: Row(
            //       children: <Widget>[
            //         Container(
            //           child: Text(widget.ReservationBloc.selectedTable.title),
            //         ),
            //         CardDateDetail(
            //           width: totalWidth / 2 - (sidePadding * 2),
            //           height: totalHeight / 100 * 35,
            //           margin: EdgeInsets.only(right: cardSpace / 2),
            //           date: widget.ReservationBloc.selectedDate,
            //           backgroundColor: Colors.transparent,
            //           textColor: Theme.of(context).colorScheme.onPrimary,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: totalWidth / 2 - (sidePadding * 2),
                  margin: EdgeInsets.only(right: cardSpace / 2),
                  child: CardTable(
                    isActive: true,
                    table: ReservationBloc.selectedTable,
                    height: totalHeight / 100 * 35,
                  ),
                ),
                CardDateDetail(
                  width: totalWidth / 2 - (sidePadding * 2),
                  height: totalHeight / 100 * 35,
                  margin: EdgeInsets.only(right: cardSpace / 2),
                  date: ReservationBloc.selectedDate,
                  backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
                  backgroundColor2: Theme.of(context).colorScheme.secondary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
            personSlider
          ],
        ));
  }
}
