import 'package:flutter/material.dart';
import 'package:foodbar_flutter_core/mongodb/field.dart';

class SelectorField extends StatefulWidget {
  SelectorField({
    Key key,
    @required this.title,
    @required this.dbFields,
    @required this.onChanged,
    @required this.initialValue,
  }) : super(key: key);

  final String title;
  final List<DbField> dbFields;
  final Function(dynamic value) onChanged;
  final dynamic initialValue;

  @override
  _SelectorFieldState createState() => _SelectorFieldState();
}

class _SelectorFieldState extends State<SelectorField> {
  dynamic _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = (widget.initialValue != null) 
      ? widget.initialValue 
      : 'select one item';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.title),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 50,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                shape: BoxShape.rectangle),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(child: Text(_currentValue.toString())),
                Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
        )
      ],
    );
  }

  void onTap() {
    showDialog(
        context: context,
        builder: (con) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(10),
            title: Text('Select a ${widget.title}'),
            children: getChoiceItems(con),
          );
        });
  }

  List<Widget> getChoiceItems(BuildContext con) {
    List<Widget> list = [];

    widget.dbFields.forEach((field) {
      Widget choiceItem = ListTile(
        title: Text(field.title),
        leading: Radio(
          value: field.strvalue,
          groupValue: _currentValue,
          onChanged: (value) {
            _currentValue = value;
            widget.onChanged(_currentValue);
            Navigator.of(con).pop();
          },
        ),
      );

      list.add(choiceItem);
    });

    return list;
  }
}
