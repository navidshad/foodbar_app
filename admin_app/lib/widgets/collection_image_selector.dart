import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:foodbar_flutter_core/models/models.dart';

class CollectionImagePicker extends StatefulWidget {
  CollectionImagePicker({
    Key key,
    this.height = 300,
    this.width = 300,
    this.imageDetail,
    @required this.onSelectedImage,
  }) : super(key: key);

  final double width;
  final double height;
  final ImageDetail imageDetail;
  final Function(File file) onSelectedImage;

  @override
  _CollectionImagePickerState createState() => _CollectionImagePickerState();
}

class _CollectionImagePickerState extends State<CollectionImagePicker> {
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChilds = [];
    bool hasUrl = widget.imageDetail.isAbsolute;

    // image preview
    Widget imagePreview;
    // show from selected file

    if (_imageFile != null) {
      imagePreview = Image.file(
        _imageFile,
        fit: BoxFit.cover,
      );
    }
    // show from network
    else if (hasUrl) {
      imagePreview = Image.network(
        widget.imageDetail.getUrl(),
        fit: BoxFit.cover,
      );
    } else {
      imagePreview = Container(
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        color: Colors.grey,
        child: Text('No image uploaded, yet'),
      );
    }

    stackChilds.add(imagePreview);

    // select button
    Widget selectButton = Container(
      width: widget.width,
      height: widget.height,
      alignment: Alignment.bottomCenter,
      child: OutlineButton(
        child: Text('Pick Image'),
        onPressed: pickImage,
      ),
    );

    stackChilds.add(selectButton);

    // return Stack(
    //   children: stackChilds,
    //   overflow: Overflow.clip,
    // );

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: stackChilds,
        overflow: Overflow.clip,
      ),
    );
  }

  void pickImage() async {
    ImagePicker.pickImage(source: ImageSource.gallery)
        .catchError((onError) {
      print('Image has not been selected: ' + onError.toString());
    }).then((file) {
      _imageFile = file;
      widget.onSelectedImage(_imageFile);
      setState(() {});
    });
  }
}
