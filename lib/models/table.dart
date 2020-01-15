class CustomTable {
  String title;
  String imageUrl;

  CustomTable({this.title, this.imageUrl});
}

class BoardTable extends CustomTable {
  int persons;
  int count;

  BoardTable({
    this.persons,
    this.count,
    String title,
    String imageUrl,
  }) : super(title: title, imageUrl: imageUrl);
}

class RollBandTable extends CustomTable {
  int persons;

  RollBandTable({
    this.persons,
    String title,
    String imageUrl,
  }) : super(title: title, imageUrl: imageUrl);
}
