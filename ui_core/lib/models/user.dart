import './permission.dart';
import 'package:foodbar_flutter_core/settings/types.dart';
import 'package:foodbar_flutter_core/mongodb/field.dart';

class User {
  Permission _permission;
  UserType type;

  /// this is a ref id
  String id;
  String fullname;
  String email;
  String imgStamp;

  User({
    this.id,
    this.email,
    this.fullname,
    this.type,
    this.imgStamp,
    Permission permission,
  }) {
    _permission = permission;
  }

  Map getAsDocument() {
    return {
      'refId': id,
      'email': email,
      'fullname': fullname,
      'permission': _permission.getAsDocument()
    };
  }

  factory User.fromMap(Map detail, Map permissionDetail) {
    Permission permission = Permission.fromMap(permissionDetail);

    User user = User(
      id: detail['refId'],
      email: detail['email'],
      fullname: detail['fullname'],
      type: User.getType(detail['type']),
      permission: permission,
    );

    return user;
  }

  static List<DbField> getDbFields() {
    return [
      DbField(
        'email',
      ),
      DbField('permission', fieldType: FieldType.select, subFields: []),
      DbField(
        'phone',
      ),
    ];
  }

  static UserType getType(String type) {
    if (type == 'user')
      return UserType.user;
    else
      return UserType.anonymous;
  }

  bool hasAccess(PermissionType type) {
    bool access = false;
    if (_permission != null) access = _permission.hasAccess(type);

    return access;
  }
}
