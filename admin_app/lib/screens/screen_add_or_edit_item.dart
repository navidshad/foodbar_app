import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'package:foodbar_admin/bloc/bloc.dart';
import 'package:foodbar_flutter_core/mongodb/field.dart';
import 'package:foodbar_flutter_core/widgets/widgets.dart';
import 'package:foodbar_admin/settings/app_properties.dart';
import 'package:foodbar_admin/widgets/widgets.dart';

class AddOrEditeItem extends StatefulWidget {
  AddOrEditeItem(
      {Key? key,
      this.isNew = true,
      this.hasImage = false,
      this.editingDoc = const {},
      required this.dbFields,
      required this.bloc})
      : super(key: key);

  final bool isNew;
  final bool hasImage;
  final Map editingDoc;
  final List<DbField> dbFields;
  final CollectionEditorBloc? bloc;

  @override
  _AddOrEditeItemState createState() => _AddOrEditeItemState();
}

class _AddOrEditeItemState extends State<AddOrEditeItem> {
  late ProgressDialog pd;
  late File _imageFile;
  Map? doc;

  @override
  Widget build(BuildContext context) {
    String title = widget.isNew ? 'New Item' : 'Edite Item';
    String actonBtnLable = widget.isNew ? 'Create' : 'Update';
    double buttonsHeght = 50;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        padding: EdgeInsets.all(30),
        children: <Widget>[
          CollectionObjectEditorInput(
            bloc: widget.bloc,
            dbFields: widget.dbFields,
            hasImage: widget.hasImage,
            doc: widget.editingDoc,
            onObjectChanged: (Map changed) {
              setState(() {
                doc = changed;
              });
            },
            onImageSelected: (imageFile) => _imageFile = imageFile,
          ),
          Container(
            height: 30,
          ),
          CardButton(
            title: actonBtnLable,
            height: buttonsHeght,
            margin: EdgeInsets.only(bottom: 15),
            mainColor: AppProperties.mainColor,
            disabledColor: AppProperties.disabledColor,
            textOnDisabled: AppProperties.textOnDisabled,
            textOnMainColor: AppProperties.textOnMainColor,
            onTap: onTapButtons,
          ),
          CardButton(
            title: 'Cancel',
            height: buttonsHeght,
            isOutline: true,
            //margin: EdgeInsets.all(10),
            mainColor: AppProperties.mainColor,
            disabledColor: AppProperties.disabledColor,
            textOnDisabled: AppProperties.textOnDisabled,
            textOnMainColor: AppProperties.textOnMainColor,
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void onTapButtons() {
    pd = ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.download);

    CollectionEditorBlocEvent event;
    String message =
        (widget.isNew) ? 'Creating a new Item' : 'Updating the item';

    pd.style(message: message, progressWidget: CircularProgressIndicator());

    pd.show();

    if (widget.isNew)
      event = CreateDocEvent(
          doc: doc!, onDone: onDocOperationDone, onError: onError);
    else {
      if (doc == null) doc = Map.from(widget.editingDoc);

      event = UpdateDocEvent(
          query: {'_id': doc!['_id']},
          update: doc!,
          onDone: onDocOperationDone,
          onError: onError);
    }

    widget.bloc!.eventSink.add(event);
  }

  void onDocOperationDone() async {
    // upload image if it was selected
    if (_imageFile != null) {
      pd.update(message: 'Uploading Image...');
      var event = UploadImageEvent(
        id: doc!['_id'],
        file: _imageFile,
        onTransform: (percent) =>
            pd.update(message: 'Uploading Image $percent\%'),
        onDone: () {
          pd.update(message: 'Image Uploaded!');
          Future.delayed(Duration(milliseconds: 300));
          pd.hide();
          Navigator.of(context).pop();
        },
        onError: onError,
      );

      widget.bloc!.eventSink.add(event);

      // or return back to collection viewer
    } else {
      pd.update(message: 'Done!');
      Future.delayed(Duration(milliseconds: 300));
      pd.hide();
      Navigator.of(context).pop();
    }
  }

  void onError(dynamic error) {
    pd.update(message: 'Error!');
    Future.delayed(Duration(milliseconds: 300));
    pd.hide();

    showDialog(
        context: context,
        builder: (con) => AlertDialog(
              title: Text('Somthing went wrong'),
              content: Text(error.toString()),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('ok'),
                )
              ],
            ));
  }
}
