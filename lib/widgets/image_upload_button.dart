import 'package:flutter/material.dart';
import 'package:naylors_client/widgets/widgets.dart';

class ImageUploadButton extends StatelessWidget {
  const ImageUploadButton(
      {Key key, @required this.parent, @required this.style})
      : assert(parent != null && style != null);

  final ProductEditState parent;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
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
              Material(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(2.0),
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child:
                        Icon(Icons.camera_alt, size: 48, color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Image uploads are currently unavailable.",
                    style: style,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
