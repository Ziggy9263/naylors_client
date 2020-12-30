import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/widgets/widgets.dart';

class ProductEditSizes extends StatelessWidget {
  ProductEditSizes({
    Key key,
    @required this.style,
    @required this.fields,
    @required this.parent,
  }) : super(key: key);

  final TextStyle style;
  final ProductEditFields fields;
  final ProductEditState parent;
  final ScrollController sizeController = ScrollController();

  @override
  Widget build(BuildContext context) {
    TextStyle sizeDependentStyle = style.copyWith(
      color: (fields.sizeSelected != null) ? Colors.white : Colors.white70,
      fontSize: 18,
    );
    Color sizeDependentColor = (fields.sizeSelected != null)
        ? Colors.lightBlue
        : Colors.lightBlue[100];
    if ((fields.sizeSelected ?? -1) + 1 > fields.sizes.length)
      fields.sizeSelected = null;
    return Column(
      children: [
        Stack(children: <Widget>[
          Divider(),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                "Sizes",
                style: style.copyWith(fontSize: 14),
              ),
            ),
          ),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              color: Colors.lightBlue,
              child: Center(
                child: Text("Add",
                    style: style.copyWith(color: Colors.white, fontSize: 18)),
              ),
              onPressed: () {
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  parent.setState(() {
                    fields.sizes.add({'tag': '', 'size': ''});
                    fields.size = fields.sizes.length - 1;
                    for (int i = 0; i < fields.sizes.length; i++) {
                      if (fields.sizeSelected == i) {
                        sizeController.animateTo(
                          i * 80.0, duration: new Duration(seconds: 1), curve: Curves.ease);
                        break;
                      }
                    }
                  });
                });
                sizeController.animateTo(
                  sizeController.position.maxScrollExtent,
                  duration: Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                );
              },
            ),
            RaisedButton(
              color: sizeDependentColor,
              child: Center(
                child: Text(
                  "Remove",
                  style: sizeDependentStyle,
                ),
              ),
              onPressed: (fields.sizeSelected != null)
                  ? () {
                      SchedulerBinding.instance
                          .addPostFrameCallback((timeStamp) {
                        parent.setState(() {
                          fields.sizes.removeAt(fields.sizeSelected);
                          var alg = 
                          (fields.sizeSelected ?? -1) + 1 > fields.sizes.length;
                          if (alg)
                            fields.size = (fields.sizes.length - 1);
                        });
                      });
                    }
                  : () {
                      parent.setState(() {});
                    },
            ),
            RaisedButton(
              color: sizeDependentColor,
              child: Center(
                child: Text(
                  "Deselect",
                  style: sizeDependentStyle,
                ),
              ),
              onPressed: () {
                parent.setState(() {
                  fields.sizeSelected = null;
                });
              },
            ),
          ],
        ),
        (fields.sizes.length > 0) ? Container(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 40,
              maxHeight: 80,
            ),
            child: ListView.builder(
              controller: sizeController,
              scrollDirection: Axis.horizontal,
              itemCount: fields.sizes.length,
              itemBuilder: (context, index) {
                return Material(
                  child: InkWell(
                    highlightColor: Colors.lightBlue,
                    onTap: () {
                      parent.setState(() {
                        fields.size = index;
                      });
                    },
                    child: Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: (fields.sizeSelected == index)
                            ? Colors.lightBlue[100]
                            : Colors.lightBlue[50],
                      ),
                      padding: EdgeInsets.all(4.0),
                      margin: EdgeInsets.all(2.0),
                      child: Column(
                        children: <Widget>[
                          Text("Tag"),
                          Text("${fields.sizes[index]['tag']}", style: style),
                          Text("Size"),
                          Text("${fields.sizes[index]['size']}", style: style),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ) : Container(),
        SizedBox(height: 8.0),
        Container(
          height: (fields.sizeSelected != null) ? 40 : 0,
          child: (fields.sizeSelected != null)
              ? Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: fields.sizeTag,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        enabled: (fields.tag.text.isNotEmpty),
                        style: style,
                        minLines: 5,
                        maxLines: null,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 5.0),
                          hintText: "Tag",
                          labelText: "Tag",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorMaxLines: 3,
                        ),
                        onChanged: (_) {
                          parent.setState(() {
                            fields.sizes[fields.sizeSelected]['tag'] =
                                fields.sizeTag.text;
                          });
                        },
                        onTap: () {
                          parent.setState(() {});
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a tag for this size';
                          }

                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: TextFormField(
                        controller: fields.sizeSize,
                        obscureText: false,
                        keyboardType: TextInputType.name,
                        enabled: (fields.tag.text.isNotEmpty),
                        style: style,
                        minLines: 5,
                        maxLines: null,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 5.0),
                          hintText: "Size",
                          labelText: "Size",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorMaxLines: 3,
                        ),
                        onChanged: (_) {
                          parent.setState(() {
                            fields.sizes[fields.sizeSelected]['size'] =
                                fields.sizeSize.text;
                          });
                        },
                        onTap: () {
                          parent.setState(() {});
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a size';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                )
              : Container(),
        )
      ],
    );
  }
}
