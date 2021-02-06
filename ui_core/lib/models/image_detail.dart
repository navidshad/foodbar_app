class ImageDetail {
  String id;
  String type = '';
  String imgStamp = '';
  String host;
  String db;
  String collection;

  ImageDetail(Map detail, {this.id, this.host, this.collection, this.db}) {
    
    if(detail == null) return;

    type = detail['type'];
    imgStamp = detail['imgStamp'].toString();
  }
  
  String getUrl() {
    return '$host/$db-$collection/$id-$imgStamp.${type.split('/').last}';
  }

  bool get isAbsolute {
    return (type.length == 0) ? false : true;
  }
}