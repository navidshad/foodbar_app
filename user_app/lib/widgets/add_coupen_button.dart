import 'package:flutter/material.dart';

class AddCoupenButton extends StatefulWidget {
  AddCoupenButton({
    Key key,
    @required this.onAddedCoupen,
    @required this.onRemovedCoupen,
    this.isPending = false,
  }) : super(key: key);

  final Function(String code) onAddedCoupen;
  final Function onRemovedCoupen;
  final bool isPending;

  @override
  _AddCoupenButtonState createState() => _AddCoupenButtonState();
}

class _AddCoupenButtonState extends State<AddCoupenButton> {
  BuildContext _context;
  String code;

  @override
  Widget build(BuildContext context) {
    Widget body;
    _context = context;

    if (code == null) {
      body = OutlineButton(
        child: Text('+ADD',
            textScaleFactor: 0.8,
            style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: openCoupenDialog,
      );
    } else {
      body = Row(
        children: [],
      );
    }

    return body;
  }

  void openCoupenDialog() {
    showDialog(
        context: _context,
        builder: (context) {
          return AlertDialog(
            content: TextFormField(
              autofocus: true,
              maxLength: 50,
              decoration: InputDecoration(
                labelText: 'Coupen',
                hintText: 'write coupen code',
              ),
              onChanged: (value) => code = value,
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () {},
                child: Text('Submit'),
              ),
            ],
          );
        });
  }
}
