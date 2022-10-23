import 'dart:async';
import 'package:foodbar_flutter_core/models/user.dart';

abstract class AuthInterface {
  Stream<bool> get loginEvent;

  User? _user;
  User? get user => _user;

  String? token;
  bool isLogedIn = false;
  bool isFirstEnter = false;
  bool get isLogedInAsUser;

  Future<bool> loginWithLastSession();

  Future<dynamic> login(
      {required String identity,
      required String identityType,
      required String password});

  Future<dynamic> loginAnonymous();

  Future<dynamic> varifyToken(String token);

  Future<dynamic> registerSubmitId(
      {required String identity, required String identityType});

  Future<dynamic> registerSubmitPass(
      {required String identity, required String password, int? serial});

  Future<dynamic> changePass(
      {required String identity, required String password, int? serial});

  Future<dynamic> getPermission(String permissionId);

  Future<bool> validateCode({required String id, required int code});

  Future<void> saveSession();

  void logout();
}
