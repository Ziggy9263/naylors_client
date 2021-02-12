import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naylors_client/widgets/widgets.dart';

class ImageUploadButton extends StatefulWidget {
  const ImageUploadButton(
      {Key key, @required this.parent, @required this.style})
      : assert(parent != null && style != null);

  final ProductEditState parent;
  final TextStyle style;

  @override
  _ImageUploadButtonState createState() =>
      _ImageUploadButtonState(parent: parent, style: style);
}

class _ImageUploadButtonState extends State<ImageUploadButton> {
  _ImageUploadButtonState(
      {Key key, @required this.parent, @required this.style})
      : assert(parent != null && style != null);

  final ProductEditState parent;
  final TextStyle style;

  File _imageFile;
  final picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) _imageFile = File(pickedFile.path);
    });
  }

  Future<void> uploadImageToFirebase(BuildContext context) async {
    String fileName = (_imageFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _imageFile == null ? 208 : null,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Divider(),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Text(
                    "Image",
                    style: style.copyWith(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(2.0),
                      child: InkWell(
                        onTap: () {
                          pickImage(ImageSource.camera);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(Icons.camera_alt,
                              size: 48, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(2.0),
                      child: InkWell(
                        onTap: () {
                          pickImage(ImageSource.gallery);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(Icons.upload_file,
                              size: 48, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: (_imageFile == null)
                      ? Text(
                          "No images selected.",
                          style: style,
                          textAlign: TextAlign.center,
                        )
                      : Image.file(_imageFile),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
