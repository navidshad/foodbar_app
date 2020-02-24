class ReservedTable {
  String id;
  String refId;
  String tableId;
  DateTime from;
  DateTime to;
  int persons;
  int totalPersonOnTable;
  int reservedId;

  ReservedTable(
      {this.id,
      this.refId,
      this.tableId,
      this.from,
      this.to,
      this.persons,
      this.totalPersonOnTable,
      this.reservedId});

  factory ReservedTable.fromMap(Map detail) {
    return ReservedTable(
        id: detail['_id'],
        refId: detail['refId'],
        tableId: detail['tableId'],
        from: DateTime.parse(detail['from']),
        to: DateTime.parse(detail['to']),
        persons: detail['persons'],
        totalPersonOnTable: detail['totalPersonOnTable'],
        reservedId: detail['reservedId']);
  }
}
