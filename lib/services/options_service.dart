import 'package:foodbar_user/settings/app_properties.dart';

class OptionsService {
  AppProperties properties = AppProperties();

  OptionsService.privateConstructor();
  static OptionsService instance = OptionsService.privateConstructor();
}