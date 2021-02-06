import 'package:foodbar_flutter_core/interfaces/content_provider.dart';
import 'package:foodbar_admin/screens/screens.dart';
import 'package:flutter/material.dart';

import 'package:foodbar_flutter_core/models/models.dart';
import 'package:foodbar_flutter_core/services/services.dart';
import 'package:foodbar_admin/bloc/bloc.dart';
import 'package:foodbar_admin/settings/settings.dart';
import 'package:foodbar_admin/widgets/widgets.dart';

class AppFrame extends StatefulWidget {
  @override
  _AppFrameState createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame>
    with SingleTickerProviderStateMixin {
  AppFrameBloc bloc;
  FrameTabType currentTab;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 12);
    _tabController.addListener(onTabViewChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<AppFrameBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      drawerScrimColor: Colors.transparent,
      body: StreamBuilder<AppFrameState>(
        stream: bloc.stateStream,
        initialData: bloc.getInitialState(),
        builder: (stateContext, AsyncSnapshot<AppFrameState> snapshot) {
          currentTab = AppFrameBloc.currentType; //snapshot.data.type;
          _tabController.index = currentTab.index;

          return TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              BlocProvider(
                child: Center(
                  child: Text('Dashboard'),
                ),
                bloc: null,
              ),
              CollectionEditorTab(
                database: 'user',
                collection: 'factor',
                getDbFieldsMethod: () => Factor.getDbFields(),
                tabTypeStream: bloc.tabTypeStream,
                type: FrameTabType.ORDERS,
                allowInsert: false,
              ),
              CollectionEditorTab(
                database: 'user',
                collection: 'reservedTable',
                getDbFieldsMethod: () => ReservedTable.getDbFields(),
                tabTypeStream: bloc.tabTypeStream,
                type: FrameTabType.RESERVED,
                allowInsert: false,
                allowUpdate: false,
              ),
              CollectionEditorTab(
                database: 'cms',
                collection: 'coupen',
                getDbFieldsMethod: () => Coupen.getDbFields(),
                tabTypeStream: bloc.tabTypeStream,
                type: FrameTabType.COUPEN,
              ),
              CollectionEditorTab(
                database: 'cms',
                collection: 'foodCategory',
                tabTypeStream: bloc.tabTypeStream,
                type: FrameTabType.CATEGORIES,
                hasImage: true,
                getDbFieldsMethod: () => Category.getDbFields(),
                onOperation: (event, setStateSink) {
                  ContentProvider cp = ContentService.instance;

                  // update categories and refresh the state of tab
                  if (event is UpdateDocEvent || event is RemoveDocsEvent)
                    cp.updateCategories().then((r) => setStateSink.add(true));
                },
              ),
              CollectionEditorTab(
                database: 'cms',
                collection: 'food',
                tabTypeStream: bloc.tabTypeStream,
                type: FrameTabType.FOODS,
                hasImage: true,
                getDbFieldsMethod: () {
                  List<DbField> dbFields = Food.getDbFields();
                  ContentProvider cp = ContentService.instance;

                  cp.categories.forEach((category) {
                    DbField categoryField =
                        DbField(category.title, strvalue: category.id);
                    dbFields
                        .firstWhere((field) => (field.key == 'category'))
                        .subFields
                        .add(categoryField);
                  });

                  return dbFields;
                },
              ),
              BlocProvider(
                child: Center(
                  child: Text('Statistics'),
                ),
                bloc: null,
              ),
              CollectionEditorTab(
                database: 'cms',
                collection: 'introSlider',
                getDbFieldsMethod: () => IntroSlideItem.getDbFields(),
                tabTypeStream: bloc.tabTypeStream,
                type: FrameTabType.INTRO_SLIDES,
              ),
              CollectionEditorTab(
                database: 'cms',
                collection: 'table',
                getDbFieldsMethod: () => CustomTable.getDbFields(),
                tabTypeStream: bloc.tabTypeStream,
                type: FrameTabType.TABLES,
              ),
              CollectionEditorTab(
                database: 'cms',
                collection: 'period',
                getDbFieldsMethod: () => Period.getDbFields(),
                tabTypeStream: bloc.tabTypeStream,
                type: FrameTabType.PERIODS,
              ),
              CollectionEditorTab(
                database: 'cms',
                collection: 'auth',
                getDbFieldsMethodByFuture: Future(() async {
                  List<DbField> dbFields = User.getDbFields();
                  await MongoDBService.instance
                      .find(database: 'cms', collection: 'permission')
                      .then((result) {
                    List pList = result as List;
                    pList.forEach((permission) {
                      var permissionField = DbField(permission['_id'],
                          customTitle: permission['title']);
                      dbFields
                          .firstWhere((f) => (f.key == 'permission'))
                          .subFields
                          .add(permissionField);
                    });
                  });

                  return dbFields;
                }),
                tabTypeStream: bloc.tabTypeStream,
                type: FrameTabType.USERS,
              ),
              SettingsTab(
                tabTypeStream: bloc.tabTypeStream,
                type: FrameTabType.SETTINGS,
              )
            ],
          );
        },
      ),
    );
  }

  void onTabViewChanged() {
    //FrameTabType type = AppFrameBloc.switchType(currentTab);
    //sbloc.add(ChangeAppBarAppFrameEvent(type));
  }

  void switchTab(FrameTabType type) {
    //bloc.eventSink.add(AppFrameEvent(type));
    _tabController.index = currentTab.index;
  }

  @override
  void dispose() {
    //bloc.dispose();
    super.dispose();
  }
}
