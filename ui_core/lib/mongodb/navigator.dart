class MongoNavigatorDetail {
  int pages;
  int page;
  int from;
  int to;

  Map getMap() {
    return {'pages': pages, 'page': page, 'from': from, 'to': to};
  }

  int get next {
    if (page < pages)
      return page + 1;
    else
      return pages;
  }

  int get previous {
    int temp = page - 1;
    if (temp < 1)
      return 1;
    else
      return temp;
  }

  bool get hasNext {
    bool key = (next <= pages);
    //print('hasNext $key');
    return key;
  }

  bool get hasPrevious {
    bool key = (previous >= 1);
    //print('hasPrevious $key');
    return key;
  }

  MongoNavigatorDetail(
      {this.from = 0, this.pages = 0, this.page = 0, this.to = 0});

  factory MongoNavigatorDetail.calculate(
      {int total = 10, int page = 1, int perPage = 5}) {
    if (page <= 0) page = 1;

    int _total_pages = (total / perPage).ceil();
    if (page > _total_pages) page = _total_pages;

    int from = 0;
    if (perPage == 1)
      from = page - 1;
    else
      from = (perPage * page) - perPage;

    if (page <= 1) from = 0;

    return MongoNavigatorDetail(
        pages: _total_pages, page: page, from: from, to: perPage);
  }
}
