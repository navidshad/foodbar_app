import 'package:foodbar_flutter_core/mongodb/field.dart';

class Coupen {
  String id;
  String title;
  String code;
  int total;
  double discountPercent;
  bool isUnlimited;

  Coupen({
    required this.id,
    required this.code,
    required this.title,
    required this.total,
    this.discountPercent = 0,
    this.isUnlimited = false,
  });

  factory Coupen.fromMap(Map detail) {
    return Coupen(
      id: detail['_id'],
      title: detail['title'],
      code: detail['code'],
      total: detail['total'],
      discountPercent: detail['discount_percent'],
      isUnlimited: detail['isUnlimited'],
    );
  }

  static List<DbField> getDbFields() {
    return [
      DbField('title'),
      DbField('code'),
      DbField('discount_percent',
          dataType: DataType.float, fieldType: FieldType.text),
      DbField('total', dataType: DataType.int, fieldType: FieldType.text),
      DbField('isUnlimited',
          dataType: DataType.bool, fieldType: FieldType.checkbox),
    ];
  }
}

class Order {
  String refId;
  String title;
  String description;
  double price;

  Order({
    required this.refId,
    required this.title,
    this.description = '',
    this.price = 0,
  });

  factory Order.fromMap(Map detail) {
    return Order(
      refId: detail['refId'],
      title: detail['title'],
      description: detail['description'],
      price: detail['price'],
    );
  }

  static List<DbField> getDbFields() {
    return [
      DbField('refId'),
      DbField('title'),
      DbField('description'),
      DbField('price', dataType: DataType.float, fieldType: FieldType.text),
    ];
  }
}

class Factor {
  String id;
  bool isPaid;
  String refId;
  List<Order> orders;
  List<Order> otherCosts;
  double amount;
  String currency;
  double discount;
  String? coupenId;

  Factor({
    required this.id,
    required this.currency,
    required this.refId,
    this.amount = 0,
    this.coupenId,
    this.discount = 0,
    this.isPaid = false,
    this.orders = const [],
    this.otherCosts = const [],
  });

  static List<DbField> getDbFields() {
    return [
      DbField('isPaid', dataType: DataType.bool, fieldType: FieldType.checkbox),
      DbField('refId', isDisable: true),
      DbField('currency'),
      DbField('coupenId'),
      DbField('amount', dataType: DataType.float, fieldType: FieldType.text),
      DbField('discount', dataType: DataType.float, fieldType: FieldType.text),
      DbField('orders',
          dataType: DataType.array_object,
          fieldType: FieldType.array,
          subFields: Order.getDbFields()),
      DbField('otherCosts',
          dataType: DataType.array_object,
          fieldType: FieldType.array,
          subFields: Order.getDbFields()),
    ];
  }

  factory Factor.fromMap(Map detail) {
    return Factor(
        id: detail['_id'],
        isPaid: detail['isPaid'],
        refId: detail['refId'],
        amount: detail['amount'],
        currency: detail['currency'],
        discount: detail['discount'],
        coupenId: detail['coupenId'],
        orders: (detail['orders'] as List)
            .map((item) => Order.fromMap(item))
            .toList(),
        otherCosts: (detail['otherCosts'] as List)
            .map((item) => Order.fromMap(item))
            .toList());
  }
}
