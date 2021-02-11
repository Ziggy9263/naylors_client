import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/util/util.dart';
import 'package:naylors_client/widgets/widgets.dart';

class ProductEditBody extends StatelessWidget {
  const ProductEditBody({
    Key key,
    @required this.parent,
    @required this.products,
    @required this.fields,
    @required GlobalKey<FormState> formKey,
    @required this.focus,
    @required this.style,
    @required LayerLink layerLink,
  })  : _formKey = formKey,
        _layerLink = layerLink,
        super(key: key);

  final ProductEditFields fields;
  final ProductList products;
  final ProductEditState parent;
  final GlobalKey<FormState> _formKey;
  final ProductEditFocus focus;
  final TextStyle style;
  final LayerLink _layerLink;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Form(
          key: _formKey,
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: FocusScope(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: fields.tag,
                            obscureText: false,
                            focusNode: focus.tag,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            style: style,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: "Product Tag (e.g. 36009)",
                              labelText: "Tag",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              errorMaxLines: 3,
                            ),
                            onChanged: (_) {
                              // ignore: invalid_use_of_protected_member
                              parent.setState(() {
                                if (_.length >= 5) {
                                  products.list.forEach((p) =>
                                      {if (p.tag == _) fields.tagless = p});
                                }
                              });
                            },
                            onTap: () {
                              // ignore: invalid_use_of_protected_member
                              parent.setState(() {});
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a number';
                              }

                              return null;
                            },
                          ),
                        ),
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Text("ROOT",
                                style: style.copyWith(
                                  color: fields.root
                                      ? Colors.lightBlue
                                      : Colors.black,
                                  fontSize: 14,
                                  fontWeight: fields.root
                                      ? FontWeight.bold
                                      : FontWeight.w300,
                                )),
                            Switch(
                                activeColor: Colors.lightBlue,
                                value: fields.root,
                                autofocus: true,
                                focusNode: focus.root,
                                onChanged: (_) {
                                  // ignore: invalid_use_of_protected_member
                                  this.parent.setState(() {
                                    fields.root = _;
                                  });
                                }),
                          ],
                        ),
                        CompositedTransformTarget(
                          link: this._layerLink,
                          child: IconButton(
                            icon: Icon(Icons.more_horiz_outlined),
                            onPressed: () {
                              parent.menuToggle = !parent.menuToggle;
                              if (parent.menuToggle) {
                                parent.overlayEntry =
                                    parent.createOverlayEntry();
                                Overlay.of(context).insert(parent.overlayEntry);
                              } else {
                                parent.overlayEntry.remove();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: fields.name,
                      obscureText: false,
                      focusNode: focus.name,
                      enabled: (fields.tag.text.isNotEmpty),
                      textInputAction: TextInputAction.next,
                      style: style,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Product Name (e.g. Scratch)",
                        labelText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        errorMaxLines: 3,
                      ),
                      onChanged: (_) {
                        // ignore: invalid_use_of_protected_member
                        parent.setState(() {});
                      },
                      onTap: () {
                        // ignore: invalid_use_of_protected_member
                        parent.setState(() {});
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your name';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: fields.price,
                            obscureText: false,
                            focusNode: focus.price,
                            enabled: (fields.tag.text.isNotEmpty),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              new CurrencyTextInputFormatter(symbol: '\$')
                            ],
                            style: style,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: "Product Price (e.g. 10.95)",
                              labelText: "Price",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              errorMaxLines: 3,
                            ),
                            onChanged: (_) {
                              // ignore: invalid_use_of_protected_member
                              parent.setState(() {});
                            },
                            onTap: () {
                              // ignore: invalid_use_of_protected_member
                              parent.setState(() {});
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a price';
                              }

                              return null;
                            },
                          ),
                        ),
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            /// Inverse taxExempt means TAX yes/no
                            /// taxExempt status is true if !TAX
                            Positioned(
                              child: Text("TAX",
                                  style: style.copyWith(
                                    color: !fields.taxExempt
                                        ? Colors.lightBlue
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: !fields.taxExempt
                                        ? FontWeight.bold
                                        : FontWeight.w300,
                                  )),
                            ),
                            Switch(
                                activeColor: Colors.lightBlue,
                                value: !fields.taxExempt,
                                focusNode: focus.taxExempt,
                                onChanged: (_) {
                                  // ignore: invalid_use_of_protected_member
                                  parent.setState(() {
                                    fields.taxExempt = !_;
                                  });
                                }),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue[50],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          width: 100,
                          height: 40,
                          child: Center(
                            child: Stack(
                              children: [
                                Text(
                                    "${fields.price.text}" +
                                        "${(fields.taxExempt) ? '' : ' +Tax'}",
                                    style: style.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 1
                                        ..color = Colors.lightGreen[800],
                                    )),
                                Text(
                                    "${fields.price.text}${(fields.taxExempt) ? '' : ' +Tax'}",
                                    style: style.copyWith(
                                      color: Colors.lightGreen[600],
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    DepartmentCategoryDropdowns(
                        fields: fields,
                        focus: focus,
                        style: style,
                        parent: parent),
                    (focus.description.hasFocus)
                        ? Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: EdgeInsets.all(8.0),
                                  margin: EdgeInsets.symmetric(vertical: 4.0),
                                  child: MarkdownBody(
                                    data:
                                        "**Description Preview**\n[Formatting Guide](https://guides.github.com/features/mastering-markdown/)\n\n---\n\n${fields.description.text}",
                                    styleSheet: MarkdownStyleSheet(
                                      p: style.copyWith(
                                          color: Colors.white, fontSize: 20),
                                      a: style.copyWith(
                                          color: Colors.indigo[600],
                                          fontSize: 20),
                                      horizontalRuleDecoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            width: 1.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTapLink: (_) => parent.launchUrl(_),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(height: 8.0),
                    TextFormField(
                      controller: fields.description,
                      obscureText: false,
                      focusNode: focus.description,
                      keyboardType: TextInputType.multiline,
                      enabled: (fields.tag.text.isNotEmpty),
                      style: style,
                      minLines: 5,
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Product Description",
                        labelText: "Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        errorMaxLines: 3,
                      ),
                      onChanged: (_) {
                        // ignore: invalid_use_of_protected_member
                        parent.setState(() {});
                      },
                      onTap: () {
                        // ignore: invalid_use_of_protected_member
                        parent.setState(() {});
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 4),
                    ProductEditSizes(
                        style: style, fields: fields, parent: parent),
                    ImageUploadButton(style: style, parent: parent),
                    Text(fields.toString())
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
