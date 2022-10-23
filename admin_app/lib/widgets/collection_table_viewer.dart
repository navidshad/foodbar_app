import 'package:flutter/material.dart';
import 'package:foodbar_admin/settings/types.dart';
import 'package:foodbar_flutter_core/foodbar_flutter_core.dart';

import 'package:foodbar_flutter_core/utilities/text_util.dart';
import 'package:foodbar_flutter_core/mongodb/mongodb.dart';
import 'package:foodbar_admin/bloc/bloc.dart';
import 'package:foodbar_admin/bloc/collection_editor_bloc.dart';
import 'package:foodbar_admin/widgets/widgets.dart';

class CollectionTableViewer extends StatelessWidget {
  CollectionTableViewer(
      {Key? key,
      required this.dbFields,
      required this.onFieldTap,
      required this.docs,
      required this.bloc})
      : super(key: key);

  final List<DbField> dbFields;
  final Function(Map doc) onFieldTap;
  final CollectionEditorBloc bloc;
  List<Map> docs;

  List<DbField> get visibleFields => dbFields.where((f) => !f.isHide).toList();

  TableRow getTitlesRow() {
    List<Widget> childs = [];

    visibleFields.forEach((field) {
      Container fieldWidget = Container(
          padding: EdgeInsets.all(5),
          child: Text(
            TextUtil.toUperCaseForLable(field.title),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ));

      childs.add(fieldWidget);
    });

    return TableRow(
      children: childs,
    );
  }

  double getTableWide() {
    double columnWide = 220;
    double maxWide = visibleFields.length * columnWide;

    return maxWide;
  }

  TableRow getTableRowByDoc(Map doc) {
    List<Widget> rowFields = [];

    List<String> visibleKeys = visibleFields.map((f) => f.key).toList();

    visibleKeys.forEach((key) {
      String value = doc[key].toString();

      Widget fieldContent = Container(
        padding: EdgeInsets.all(10),
        child: Text(
          value,
          textAlign: TextAlign.center,
        ),
      );

      if (key == 'image') {
        var imageDetail = ImageDetail(
          doc[key],
          db: bloc.database,
          collection: bloc.collection,
          host: MongoDBService.host,
          id: doc['_id'],
        );

        fieldContent = Container(
          padding: EdgeInsets.all(10),
          child: Image.network(imageDetail.getUrl()),
        );
      }

      Widget tableField = InkWell(
        onTap: () {
          onFieldTap(doc);
        },
        child: fieldContent,
      );

      rowFields.add(tableField);
    });

    return TableRow(children: rowFields);
  }

  Table getTableByDocList(List<Map> docs) {
    List<TableRow> tableRows = [];

    docs.forEach((doc) {
      tableRows.add(getTableRowByDoc(doc));
    });

    return Table(
      border: TableBorder(
          horizontalInside: BorderSide(
        width: 0.5,
        color: Colors.grey,
      )),
      children: tableRows,
    );
  }

  @override
  Widget build(BuildContext context) {
    Table tableHeader = Table(
      children: [getTitlesRow()],
    );

    Table table = getTableByDocList(docs);

    SingleChildScrollView detailSection = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(15),
      child: Container(
          width: getTableWide(),
          child: Column(
            children: <Widget>[
              tableHeader,
              Expanded(
                  child: ListView(
                children: <Widget>[table],
              )),
            ],
          )),
    );

    return detailSection;
  }
}
