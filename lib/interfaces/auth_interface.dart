import 'dart:async';
import 'package:Food_Bar/models/user.dart';

abstract class AuthInterface {
  
  Stream<bool> get loginEvent;

  User _user;
  User get user => _user;

  String token;
  bool isLogedIn;

  Future<dynamic> login({String identity, String identityType, String password});

  Future<dynamic> loginAnonymous({String identity, String identityType, String password});

  Future<dynamic> varifyToken(String token);

  Future<dynamic> registerSubmitId({String identity, String identityType});

  Future<dynamic> registerSubmitPass({String identity, String password, int serial});

  Future<dynamic> changePass({String identity, String password, int serial});

  Future<dynamic> getPermission(String permissionId);

  Future<bool> validateCode({String id, int code});

  void logout();

  Future<dynamic> loginWithLastSession();
}
