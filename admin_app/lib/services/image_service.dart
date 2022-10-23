import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:foodbar_admin/settings/settings.dart';
import 'package:foodbar_flutter_core/services/services.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

class ImageService {
  ImageService.privateConstructor();
  static ImageService instance = ImageService.privateConstructor();

  final Client client = Client();

  Future<void> upload(
      {required String database,
      required String collection,
      required String id,
      required File file,
      Function(int persent)? onTransform}) async {
    Completer completer = Completer();
    Uri uri = Uri.parse(Vars.host + '/image/upload');
    var request = MultipartRequest('POST', uri);

    request.fields['database'] = database;
    request.fields['type'] = collection;
    request.fields['id'] = id;

    request.headers['authorization'] = AuthService.instant.token!;

    int length = await file.length();
    String filename = file.path.split('/').last;
    String subtype = filename.split('.').last;

    request.files.add(MultipartFile('image', file.openRead(), length,
        filename: filename, contentType: MediaType('image', subtype)));

    request.send().then((streamResponse) {
      streamResponse.stream.transform(utf8.decoder).listen(
        (value) {
          print(value);
        },
        onDone: () {
          completer.complete();
        },
        onError: (error) {
          completer.completeError(error);
        },
      );

      if (streamResponse.statusCode != 200)
        completer.completeError('Image uploader error!');
    }).catchError((onError) {
      completer.completeError(onError.toString());
    });

    return completer.future;
  }
}
