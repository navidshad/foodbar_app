class Food {
  String id;
  String categoryId;
  String title;
  String subTitle;
  String description;
  String imageUrl;

  Food({this.id, this.categoryId, this.title, this.subTitle, this.description, this.imageUrl});

  factory Food.fromMap(Map detail) {
    return Food(
      id: detail['_id'], 
      title: detail['title'],
      subTitle: detail['subTitle'],
      description: detail['description'],
      imageUrl: detail['imageUrl']);
  }
}
