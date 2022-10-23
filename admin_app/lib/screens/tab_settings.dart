import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodbar_admin/bloc/collection_editor_bloc.dart';

import 'package:foodbar_admin/bloc/bloc.dart';
import 'package:foodbar_admin/settings/app_properties.dart';
import 'package:foodbar_admin/settings/types.dart';
import 'package:foodbar_admin/widgets/widgets.dart';
import 'package:foodbar_flutter_core/mongodb/field.dart';
import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_flutter_core/widgets/widgets.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class SettingsTab extends StatefulWidget {
  SettingsTab({
    Key? key,
    required this.tabTypeStream,
    required this.type,
    this.onOperation,
  }) : super(key: key);

  final String database = 'cms';
  final String collection = 'settings';
  final List<DbField> dbFields = Settings.getDbFields();

  final Stream<FrameTabType> tabTypeStream;
  final FrameTabType type;
  final Function(
          CollectionEditorBlocEvent event, StreamSink<bool> setStateSink)?
      onOperation;

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  StreamController<bool> _setStateStream = StreamController();
  late CollectionEditorBloc bloc;
  late ProgressDialog pd;
  bool allowGetOptionOnBuild = false;
  late Map settingsDoc;

  @override
  void initState() {
    super.initState();
    widget.tabTypeStream.listen(onTabTypeReceived);

    _setStateStream.stream.listen((bool key) {
      if (key) setState(() {});
    });

    bloc = CollectionEditorBloc(
        database: widget.database, collection: widget.collection);

    bloc.operationStream.listen((event) {
      if (widget.onOperation != null)
        widget.onOperation!(event, _setStateStream.sink);
    });

    bloc.stateStream.listen((state) {
      setState(() {
        settingsDoc = Map.from(state.docs.last);
      });
    });
  }

  @override
  void dispose() {
    _setStateStream.close();
    super.dispose();
  }

  void onTabTypeReceived(FrameTabType currentType) {
    if (currentType != widget.type) return;
    allowGetOptionOnBuild = true;
  }

  void getOption() {
    allowGetOptionOnBuild = false;
    var event = GetDocsEvent(page: bloc.navigatorDetail.page);
    bloc.eventSink.add(event);
  }

  @override
  Widget build(BuildContext context) {
    if (allowGetOptionOnBuild) getOption();

    String actonBtnLable = 'Update';
    double buttonsHeght = 50;

    Widget state;

    if (settingsDoc == null) {
      state = Center(
        child: CircularProgressIndicator(),
      );
    } else {
      state = ListView(
        padding: EdgeInsets.all(30),
        children: <Widget>[
          CollectionObjectEditorInput(
            bloc: bloc,
            dbFields: widget.dbFields,
            hasImage: false,
            doc: settingsDoc ?? {},
            onObjectChanged: (Map changed) {
              setState(() {
                settingsDoc = changed;
              });
            },
            onImageSelected: (imageFile) {},
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
            onTap: (settingsDoc != null) ? onTapButtons : null,
          ),
        ],
      );
    }

    return state;
  }

  void onTapButtons() {
    pd = ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.download);

    CollectionEditorBlocEvent event;
    String message = 'Updating Options';

    pd.style(message: message, progressWidget: CircularProgressIndicator());

    pd.show();

    event = UpdateDocEvent(
        query: {'_id': settingsDoc['_id']},
        update: settingsDoc,
        onDone: onDocOperationDone,
        onError: onError);

    bloc.eventSink.add(event);
  }

  void onDocOperationDone() async {
    // upload image if it was selected
    // if (false) {
    //   pd.update(message: 'Uploading Image...');
    //   var event = UploadImageEvent(
    //     id: settingsDoc['_id'],
    //     file: null,
    //     onTransform: (percent) =>
    //         pd.update(message: 'Uploading Image $percent\%'),
    //     onDone: () {
    //       pd.update(message: 'Image Uploaded!');
    //       Future.delayed(Duration(milliseconds: 300));
    //       pd.hide();
    //       Navigator.of(context).pop();
    //     },
    //     onError: onError,
    //   );

    //   bloc.eventSink.add(event);

    //   // or return back to collection viewer
    // } else {
    //   pd.update(message: 'Done!');
    //   Future.delayed(Duration(milliseconds: 300));
    //   pd.hide();
    //   Navigator.of(context).pop();
    // }

    pd.update(message: 'Done!');
    Future.delayed(Duration(milliseconds: 300));
    pd.hide();
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
