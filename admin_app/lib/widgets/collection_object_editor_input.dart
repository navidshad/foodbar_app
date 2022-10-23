import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodbar_admin/settings/static_vars.dart';
import 'dart:async';
import 'package:rxdart/subjects.dart';

import 'package:foodbar_admin/services/services.dart';
import 'package:foodbar_admin/bloc/collection_editor_bloc.dart';
import 'package:foodbar_flutter_core/models/models.dart';
import './widgets.dart';

class CollectionObjectEditorInput extends StatefulWidget {
  final title;
  final Function(Map edited) onObjectChanged;
  final Function(File imageFile) onImageSelected;
  final List<DbField> dbFields;
  final hasImage;
  final Map doc;
  final CollectionEditorBloc bloc;

  CollectionObjectEditorInput({
    this.title,
    required this.bloc,
    required this.onObjectChanged,
    required this.onImageSelected,
    required this.dbFields,
    this.hasImage = false,
    this.doc = const {},
    Key? key,
  }) : super(key: key);

  @override
  _CollectionObjectEditorInputState createState() =>
      _CollectionObjectEditorInputState();
}

class _CollectionObjectEditorInputState
    extends State<CollectionObjectEditorInput> {
  StreamController<Map> _editController = BehaviorSubject();
  // StreamSink<Map> get updateSink => _editController.sink;
  late Map changed;

  @override
  void initState() {
    changed = Map.from(widget.doc ?? {});
    _editController.stream.listen(widget.onObjectChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> inputsSections = [
      if (widget.title != null)
        ListTile(
          title: Text(
            widget.title,
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
    ];
    List<DbField> dbFields = List.from(widget.dbFields);

    int imageFieldIndex =
        dbFields.indexWhere((f) => (f.fieldType == FieldType.image));
    if (imageFieldIndex != -1) {
      var imageField = dbFields[imageFieldIndex];
      dbFields.removeAt(imageFieldIndex);
      dbFields.insert(0, imageField);
      print(dbFields);
    }

    for (var i = 0; i < dbFields.length; i++) {
      DbField dbField = dbFields[i];
      Widget inputSection = getInputSection(
          dbField: dbField,
          initialValue: changed[dbField.key],
          onSubmitted: (value) {
            //print('emit changed event $value');
            try {
              changed[dbField.key] =
                  DbField.casteValue(dbField.dataType, value);
            } catch (e) {
              print(e);
            }

            _editController.add(changed);
          });

      bool allowToShow = !dbField.isHide;

      // if (widget.hasImage && dbField.fieldType == FieldType.image)
      //   allowToShow = true;

      if (allowToShow) inputsSections.add(inputSection);
    }

    return Column(
      children: inputsSections,
    );
  }

  Widget getInputSection(
      {required DbField dbField,
      required Function(dynamic value) onSubmitted,
      dynamic initialValue}) {
    //
    Widget inputSection;

    TextInputType textInputType = getKeyboard(dbField.dataType);
    FieldType fieldType = dbField.fieldType;

    switch (fieldType) {
      case FieldType.textbox:
        inputSection = SizedBox(
          height: 300,
          child: TextFormField(
            initialValue: initialValue?.toString() ?? '',
            expands: true,
            keyboardType: textInputType,
            minLines: null,
            maxLines: null,
            onChanged: (String value) => onSubmitted(value),
            decoration: InputDecoration(
                labelText: dbField.title, border: OutlineInputBorder()),
          ),
        );
        break;

      case FieldType.image:
        inputSection = CollectionImagePicker(
          imageDetail: ImageDetail(
            initialValue as Map,
            id: changed['_id'],
            host: Vars.host,
            db: widget.bloc.database,
            collection: widget.bloc.collection,
          ),
          onSelectedImage: widget.onImageSelected,
        );
        break;

      case FieldType.select:
        inputSection = SelectorField(
          title: dbField.title,
          dbFields: dbField.subFields!,
          onChanged: (value) => onSubmitted(value.toString()),
          initialValue: initialValue,
        );
        break;

      case FieldType.object:
        inputSection = CollectionObjectEditorInput(
          title: dbField.title,
          bloc: widget.bloc,
          onObjectChanged: (value) {
            onSubmitted(value);
          },
          onImageSelected: (image) {},
          dbFields: dbField.subFields!,
          doc: initialValue,
        );
        break;

      default:
        inputSection = TextFormField(
          initialValue: initialValue?.toString() ?? '',
          keyboardType: textInputType,
          onChanged: (String value) => onSubmitted(value),
          decoration: InputDecoration(
              labelText: dbField.title, border: OutlineInputBorder()),
        );
    }

    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: inputSection,
    );
  }

  TextInputType getKeyboard(DataType dataType) {
    TextInputType keyboard;

    if (dataType == DataType.int)
      keyboard = TextInputType.phone;
    else if (dataType == DataType.float)
      keyboard = TextInputType.number;
    else
      keyboard = TextInputType.text;

    return keyboard;
  }

  @override
  void dispose() {
    _editController.close();
    super.dispose();
  }
}
