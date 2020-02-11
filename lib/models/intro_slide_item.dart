class IntroSlideItem {
  String title;
  String description;
  String imageUrl;

  IntroSlideItem({this.title, this.description, this.imageUrl});

  factory IntroSlideItem.fromMap(Map detail) {
    return IntroSlideItem(
      title: detail['title'],
      description: detail['description'],
      imageUrl: detail['imageUrl'],
    );
  }
}