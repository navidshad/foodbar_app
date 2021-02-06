import 'package:foodbar_admin/settings/app_properties.dart';
export 'package:foodbar_admin/settings/app_properties.dart';

class OptionsService {
  AppProperties properties = AppProperties();

  OptionsService.privateConstructor();
  static OptionsService instance = OptionsService.privateConstructor();
}