import 'package:foodbar_flutter_core/settings/types.dart';

class Permission {
  String id;
  bool customerAccess;
  bool anonymousAccess;
  bool userManager;
  bool advancedSettings;
  bool contentProducer;

  Permission({
    required this.id,
    this.customerAccess = false,
    this.anonymousAccess = false,
    this.userManager = false,
    this.advancedSettings = false,
    this.contentProducer = false,
  });

  factory Permission.fromMap(Map detail) {
    return Permission(
      id: detail['_id'],
      customerAccess: detail['customer_access'] ?? false,
      anonymousAccess: detail['anonymous_access'] ?? false,
      userManager: detail['user_manager'] ?? false,
      advancedSettings: detail['advanced_settings'] ?? false,
      contentProducer: detail['content_sroducer'] ?? false,
    );
  }

  Map getAsDocument() {
    return {
      '_id': id,
      'customer_access': customerAccess,
      'anonymous_access': anonymousAccess,
      'user_manager': userManager,
      'advanced_settings': advancedSettings,
      'content_sroducer': contentProducer,
    };
  }

  // compare two permission class
  bool isEqualeTo(Permission per) {
    bool isEquale = true;

    if (customerAccess != per.customerAccess) isEquale = false;
    if (userManager != per.userManager) isEquale = false;
    if (advancedSettings != per.advancedSettings) isEquale = false;
    if (anonymousAccess != per.anonymousAccess) isEquale = false;
    if (contentProducer != per.contentProducer) isEquale = false;

    return isEquale;
  }

  // check access of one permission Item
  bool hasAccess(PermissionType type) {
    bool has = false;

    switch (type) {
      case PermissionType.anonymousAccess:
        has = anonymousAccess;
        break;

      case PermissionType.customerAccess:
        has = customerAccess;
        break;

      case PermissionType.userManager:
        has = userManager;
        break;

      case PermissionType.advancedSettings:
        has = advancedSettings;
        break;

      case PermissionType.contentProducer:
        has = contentProducer;
        break;

      default:
        has = false;
    }

    return has;
  }
}
