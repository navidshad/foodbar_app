import 'package:Food_Bar/interfaces/auth_interface.dart';
import 'package:Food_Bar/models/user.dart';

class MockAuthService implements AuthInterface{
  @override
  bool isLogedIn = false;

  @override
  String token;

  @override
  Future changePass({String identity, String password, int serial}) {
    // TODO: implement changePass
    return null;
  }

  @override
  Future getPermission(String permissionId) {
    // TODO: implement getPermission
    return null;
  }

  @override
  Future login({String identity, String identityType, String password}) {
    // TODO: implement login
    return null;
  }

  @override
  Future loginAnonymous({String identity, String identityType, String password}) {
    // TODO: implement loginAnonymous
    return null;
  }

  @override
  Future loginWithLastSession() {
    // TODO: implement loginWithLastSession
    return null;
  }

  @override
  void logout() {
    // TODO: implement logout
  }

  @override
  Future registerSubmitId({String identity, String identityType}) {
    // TODO: implement registerSubmitId
    return null;
  }

  @override
  Future registerSubmitPass({String identity, String password, int serial}) {
    // TODO: implement registerSubmitPass
    return null;
  }

  @override
  // TODO: implement user
  User get user => null;

  @override
  Future<bool> validateSMSCode({String id, int code}) {
    // TODO: implement validateSMSCode
    return null;
  }

  @override
  Future varifyToken(String token) {
    // TODO: implement varifyToken
    return null;
  }

  @override
  // TODO: implement loginEvent
  Stream<bool> get loginEvent => null;

}