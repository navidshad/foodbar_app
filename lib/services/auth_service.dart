import 'package:foodbar_user/interfaces/local_storage_interface.dart';
import 'package:foodbar_user/models/permission.dart';
import 'package:foodbar_user/services/shared_preferences_service.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';

import 'package:foodbar_user/interfaces/auth_interface.dart';
import 'package:foodbar_user/models/user.dart';
import 'package:foodbar_user/settings/settings.dart';
import 'package:foodbar_user/settings/types.dart';
import 'package:rxdart/rxdart.dart';

class AuthService implements AuthInterface {
  AuthService._privateConstructor();
  static final instant = AuthService._privateConstructor();

  final StreamController<bool> _loginController = BehaviorSubject<bool>();

  Client _http = Client();
  User _user;

  @override
  bool isLogedIn = false;

  @override
  String token;

  @override
  User get user => _user;

  @override
  Stream<bool> get loginEvent => _loginController.stream.asBroadcastStream();

  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Future<dynamic> login(
      {String identity, String identityType, String password}) {
    String url = Vars.host + '/user/login';

    Map body = {'id': identity, 'idType': identityType, 'password': password};

    return _http
        .post(url, body: json.encode(body), headers: headers)
        .then(_analizeResult)
        .then((rBody) => rBody['token'])
        .then((resultToken) => token = resultToken)
        // varify token
        .then((r) => varifyToken(token))
        // load user detail
        .then(_loadUserFromPayload);
  }

  void _loadUserFromPayload(dynamic payload) {
    UserType type = User.getType(payload['type']);

    Map permissionDetail = payload['permission'];
    Permission permission = Permission.fromMap(permissionDetail);

    _user = User(
      id: payload['id'],
      type: type,
      email: payload['email'],
      permission: permission,
    );

    isLogedIn = true;

    // broadcast login event
    _loginController.add(isLogedIn);
    // store this session
    saveSession();
  }

  Future<dynamic> loginAnonymous(
      {String identity, String identityType, String password}) {
    String url = Vars.host + '/user/loginAnonymous';

    return _http
        .get(url)
        .then(_analizeResult)
        .then((rBody) => rBody['token'])
        .then((resultToken) => token = resultToken)
        // varify token
        .then((r) => varifyToken(token))
        // load user detail
        .then(_loadUserFromPayload);
  }

  Future<dynamic> varifyToken(String token) {
    String url = Vars.host + '/varify/token';
    Map body = {'token': token};

    return _http
        .post(url, body: json.encode(body), headers: headers)
        .then(_analizeResult)
        .then((rBody) => rBody['peyload']);
  }

  Future<dynamic> registerSubmitId({String identity, String identityType}) {
    String url = Vars.host + '/user/register_submit_id';

    Map body = {
      'id': identity,
      'idType': identityType,
    };

    return _http
        .post(url, body: json.encode(body), headers: headers)
        .then(_analizeResult);
  }

  Future<dynamic> registerSubmitPass(
      {String identity, String password, int serial}) {
    String url = Vars.host + '/user/register_submit_pass';

    Map body = {'id': identity, 'password': password, 'serial': serial};

    return _http
        .post(url, body: json.encode(body), headers: headers)
        .then(_analizeResult);
  }

  Future<dynamic> changePass({String identity, String password, int serial}) {
    String url = Vars.host + '/user/change_pass';

    Map body = {'id': identity, 'password': password, 'serial': serial};

    return _http
        .post(url, body: json.encode(body), headers: headers)
        .then(_analizeResult);
  }

  Future<dynamic> getPermission(String permissionId) {
    String url = Vars.host + '/user/getPermission';

    Map body = {
      'id': permissionId,
    };

    return _http
        .post(url, body: json.encode(body), headers: headers)
        .then(_analizeResult)
        .then((result) => result['permission']);
  }

  Future<bool> validateCode({String id, int code}) {
    String url = Vars.host + '/user/validateCode';

    Map body = {'id': id, 'serial': code};

    return _http
        .post(url, body: json.encode(body), headers: headers)
        .then(_analizeResult)
        .then((result) => result['isValid'] as bool);
  }

  @override
  Future<bool> loginWithLastSession() async {
    LocalStorageInterface storage = SharedPreferencesService.instace;

    Map doc = await storage.findOne(AppProperties.collectionToken);
    if (doc == null) return false;

    token = doc['token'];

    // varify last token
    return varifyToken(token)
        // load user detail
        .then(_loadUserFromPayload)
        // result
        .then((r) => true)
        .catchError((onError) => false);
  }

  @override
  void logout() {
    loginAnonymous();
    isLogedIn = false;
    _loginController.add(isLogedIn);
    saveSession();
  }

  void close() {
    _loginController.close();
  }

  @override
  Future<void> saveSession() {
    LocalStorageInterface storage = SharedPreferencesService.instace;

    Map<String, dynamic> session = {'token': token};

    return storage.insert(AppProperties.collectionToken, '1', session,
        allowReplace: true);
  }

  dynamic _analizeResult(Response r) {
    dynamic body;

    try {
      body = jsonDecode(r.body);
    } catch (e) {
      throw e;
    }

    if (r.statusCode != 200) {
      String error = body['error'] ?? body.toString();
      throw error;
    }

    return body;
  }
}
