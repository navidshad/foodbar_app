import 'package:flutter/material.dart';

import 'package:foodbar_admin/settings/settings.dart';
import 'package:foodbar_admin/services/options_service.dart';
import 'package:foodbar_flutter_core/services/services.dart';
import 'package:mrest_flutter/mrest_flutter.dart';

void main() {
  // AuthService.setOptions(
  //     host: Vars.host, tokenCollection: AppProperties.collectionToken);
  // MongoDBService.setOptions(host: Vars.host);

  GlobalOptions()..setOption(baseUrl: Vars.host);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final OptionsService options = OptionsService.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: options.properties.title,
      theme: AppTheme.getData(),
      routes: AppRoutes.getRoutes(),
      initialRoute: '/splash',
      // onGenerateRoute: ,
    );
  }
}
