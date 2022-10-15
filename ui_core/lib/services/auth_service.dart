import 'package:foodbar_flutter_core/interfaces/local_storage_interface.dart';
import 'package:foodbar_flutter_core/models/permission.dart';
import 'package:foodbar_flutter_core/services/shared_preferences_service.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';

import 'package:foodbar_flutter_core/interfaces/auth_interface.dart';
import 'package:foodbar_flutter_core/models/user.dart';
import 'package:foodbar_flutter_core/settings/types.dart';
import 'package:rxdart/rxdart.dart';

class AuthService implements AuthInterface {
  AuthService._privateConstructor();

  static final instant = AuthService._privateConstructor();

  static String host;
  static String tokenCollection;

  static void setOptions({String host, String tokenCollection}) {
    if (host != null) AuthService.host = host;
    if (tokenCollection != null) AuthService.tokenCollection = tokenCollection;
  }

  final StreamController<bool> _loginController =
      BehaviorSubject<bool>(sync: false);

  Client _http = Client();
  User _user;

  @override
  bool isLogedIn = false;
  bool isFirstEnter = true;

  bool get isLogedInAsUser {
    return (_user?.type == UserType.user);
  }

  @override
  String token;

  @override
  User get user => _user;

  @override
  Stream<bool> get loginEvent => _loginController.stream;

  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Future<dynamic> login(
      {String identity, String identityType, String password}) {
    String url = AuthService.host + '/user/login';

    Map body = {'id': identity, 'idType': identityType, 'password': password};

    return _http
        .post(Uri.parse(url), body: json.encode(body), headers: headers)
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
    String url = AuthService.host + '/user/loginAnonymous';

    print(url);

    return _http
        .get(Uri.parse(url))
        .then(_analizeResult)
        .then((rBody) => rBody['token'])
        .then((resultToken) => token = resultToken)
        // varify token
        .then((r) => varifyToken(token))
        // load user detail
        .then(_loadUserFromPayload);
  }

  Future<dynamic> varifyToken(String token) {
    String url = AuthService.host + '/varify/token';
    Map body = {'token': token};

    return _http
        .post(Uri.parse(url), body: json.encode(body), headers: headers)
        .then(_analizeResult)
        .then((rBody) => rBody['peyload']);
  }

  Future<dynamic> registerSubmitId({String identity, String identityType}) {
    String url = AuthService.host + '/user/register_submit_id';

    Map body = {
      'id': identity,
      'idType': identityType,
    };

    return _http
        .post(Uri.parse(url), body: json.encode(body), headers: headers)
        .then(_analizeResult);
  }

  Future<dynamic> registerSubmitPass(
      {String identity, String password, int serial}) {
    String url = AuthService.host + '/user/register_submit_pass';

    Map body = {'id': identity, 'password': password, 'serial': serial};

    return _http
        .post(Uri.parse(url), body: json.encode(body), headers: headers)
        .then(_analizeResult);
  }

  Future<dynamic> changePass({String identity, String password, int serial}) {
    String url = AuthService.host + '/user/change_pass';

    Map body = {'id': identity, 'password': password, 'serial': serial};

    return _http
        .post(Uri.parse(url), body: json.encode(body), headers: headers)
        .then(_analizeResult);
  }

  Future<dynamic> getPermission(String permissionId) {
    String url = AuthService.host + '/user/getPermission';

    Map body = {
      'id': permissionId,
    };

    return _http
        .post(Uri.parse(url), body: json.encode(body), headers: headers)
        .then(_analizeResult)
        .then((result) => result['permission']);
  }

  Future<bool> validateCode({String id, int code}) {
    String url = AuthService.host + '/user/validateCode';

    Map body = {'id': id, 'serial': code};

    return _http
        .post(Uri.parse(url), body: json.encode(body), headers: headers)
        .then(_analizeResult)
        .then((result) => result['isValid'] as bool);
  }

  @override
  Future<bool> loginWithLastSession() async {
    LocalStorageInterface storage = SharedPreferencesService.instace;

    Map doc = await storage.findOne(AuthService.tokenCollection);
    if (doc == null) return false;

    token = doc['token'];

    // varify last token
    return varifyToken(token)
        // load user detail
        .then(_loadUserFromPayload)
        // result
        .then((_) => isLogedIn)
        .then((_) => isFirstEnter = false)
        .catchError((onError) => false);
  }

  @override
  void logout() {
    loginAnonymous();
    isLogedIn = false;
    token = null;
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

    return storage.insert(AuthService.tokenCollection, '1', session,
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
