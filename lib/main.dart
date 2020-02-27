import 'package:flutter/material.dart';

import 'package:Food_Bar/settings/settings.dart';
import 'package:Food_Bar/services/options_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  OptionsService options = OptionsService.instance;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: options.properties.title,
      theme: AppTheme.getData(),
      routes: AppRoutes.getRoutes(),
      initialRoute: '/intro',
    );
  }
}
