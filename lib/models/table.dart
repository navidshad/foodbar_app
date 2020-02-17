class CustomTable {
  String id;
  String title;
  String imageUrl;

  CustomTable({this.id, this.title, this.imageUrl});

  factory CustomTable.fromMap(Map detail) {
    CustomTable table;

    if (detail['type'] == 'Board') {
      table = BoardTable(
          id: detail['_id'],
          count: detail['count'],
          imageUrl: detail['imageUrl'],
          persons: detail['persons'],
          title: detail['title']);
    } else if (detail['type'] == 'RollBand') {
      table = RollBandTable(
        id: detail['_id'],
        imageUrl: detail['imageUrl'],
        persons: detail['persons'],
        title: detail['title'],
      );
    }

    return table;
  }
}

class BoardTable extends CustomTable {
  int persons;
  int count;

  BoardTable({
    this.persons,
    this.count,
    String title,
    String imageUrl,
    String id,
  }) : super(id: id, title: title, imageUrl: imageUrl);
}

class RollBandTable extends CustomTable {
  int persons;

  RollBandTable({
    this.persons,
    String title,
    String imageUrl,
    String id,
  }) : super(id: id, title: title, imageUrl: imageUrl);
}
