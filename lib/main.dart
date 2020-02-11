import 'package:flutter/material.dart';

import 'package:Food_Bar/settings/settings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppProperties.title,
      theme: AppTheme.getData(),
      routes: AppRoutes.getRoutes(),
      initialRoute: 'intro',
    );
  }
}
