import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/widgets/widgets.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/util/util.dart';

class CreateProduct extends StatelessWidget {
  final NaylorsHomePageState parent;
  CreateProduct(this.parent);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ProductEditFocus {
  var tag = new FocusNode();
  var name = new FocusNode();
  var description = new FocusNode();
  var price = new FocusNode();
  var taxExempt = new FocusNode();
  var root = new FocusNode();
  var category = new FocusNode();

  ProductEditFocus({tag, name, description, price, taxExempt, root, category});

  void dispose() {
    tag.dispose();
    name.dispose();
    description.dispose();
    price.dispose();
    taxExempt.dispose();
    root.dispose();
    category.dispose();
  }
}

class ProductEdit extends StatefulWidget {
  final NaylorsHomePageState parent;
  final int initProduct;
  ProductEdit(this.parent, this.initProduct);

  @override
  _ProductEditState createState() => _ProductEditState(parent, initProduct);
}

class ProductEditFields {
  TextEditingController tag;
  TextEditingController name;
  TextEditingController description;
  TextEditingController price;
  bool taxExempt = false;
  bool root = false;
  TextEditingController category;

  ProductEditFields({tag, name, description, price, taxExempt, root, category});

  init() {
    this.tag = new TextEditingController();
    this.name = new TextEditingController();
    this.description = new TextEditingController();
    this.price = new TextEditingController();
    this.category = new TextEditingController();
  }

  dispose() {
    this.tag.dispose();
    this.name.dispose();
    this.description.dispose();
    this.price.dispose();
    this.category.dispose();
  }

  set product(ProductDetail product) {
    this.tag.value = TextEditingValue(text: product.tag);
    this.name.value = TextEditingValue(text: product.name);
    this.description.value = TextEditingValue(text: product.description);
    this.price.value = TextEditingValue(text: product.price.toString());
    this.taxExempt = product.taxExempt ?? false;
    this.root = product.root ?? false;
    this.category.value = TextEditingValue(text: product.category);
  }
}

class _ProductEditState extends State<ProductEdit> {
  final NaylorsHomePageState parent;
  final int initProduct;

  _ProductEditState(this.parent, this.initProduct);

  final TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20.0,
  );
  final _formKey = GlobalKey<FormState>();
  OverlayEntry _overlayEntry;
  bool menuToggle = false;
  final LayerLink _layerLink = LayerLink();
  ProductEditFields fields = new ProductEditFields();
  ProductEditFocus focus = new ProductEditFocus();
  ProductDetail product;

  @override
  initState() {
    super.initState();
    fields.init();
  }

  @override
  dispose() {
    super.dispose();
    fields.dispose();
    focus.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
        builder: (context) => Positioned(
              width: 100,
              child: CompositedTransformFollower(
                link: this._layerLink,
                showWhenUnlinked: false,
                offset: Offset(offset.dx - 50, offset.dy - 40),
                child: Material(
                  elevation: 4.0,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.visibility),
                        title: Text('View'),
                        dense: true,
                        visualDensity: VisualDensity(horizontal: -4),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        onTap: () {
                          this.menuToggle = false;
                          this._overlayEntry.remove();
                          parent.setState(() {
                            parent.headerTitle = "Naylor's Online: Products";
                          });
                          BlocProvider.of<ProductBloc>(parent.context)
                              .add(ProductReset());
                          BlocProvider.of<NavigatorBloc>(parent.context).add(
                              NavigatorToProduct(
                                  product: int.parse(fields.tag.text)));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete'),
                        dense: true,
                        visualDensity: VisualDensity(horizontal: -4),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        onTap: () {
                          print('Delete');
                          this.menuToggle = false;
                          this._overlayEntry.remove();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
      bool loading = false;
      if (state is ProductInitial) {
        (initProduct != null)
            ? BlocProvider.of<ProductBloc>(context).add(ProductEditEvent(
                step: ProductModify.Initialize, tag: initProduct.toString()))
            : BlocProvider.of<ProductBloc>(context).add(
                ProductEditEvent(step: ProductModify.Initialize, tag: null));
      }
      if (state is ProductEditInitial) {
        if (state.product != null && this.product == null) {
          product = state.product;
          fields.product = product;
          SchedulerBinding.instance
              .addPostFrameCallback((_) => {setState(() {})});
        }
        if (state is ProductEditLoading) {
          loading = true;
        } else
          loading = false;
        if (state is ProductEditSuccess) {}
        if (state is ProductEditFailure) {}
        return Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      "We're here for ${fields.name.text}, which is a ${fields.root ? 'root' : 'non-root'} product in the ${fields.category.text} category."),
                  Form(
                      key: _formKey,
                      child: Container(
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: FocusScope(
                                  child: Column(children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: fields.tag,
                                        obscureText: false,
                                        focusNode: focus.tag,
                                        textInputAction: TextInputAction.next,
                                        style: style,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              10.0, 7.5, 10.0, 7.5),
                                          hintText: "Product Tag (e.g. 36009)",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          errorMaxLines: 3,
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter a number';
                                          }

                                          return null;
                                        },
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        /// Inverse taxExempt means TAX yes/no
                                        /// taxExempt status is true if !TAX
                                        Text("TAX",
                                            style: style.copyWith(
                                              color: !fields.taxExempt
                                                  ? Colors.lightBlue
                                                  : Colors.black,
                                              fontSize: 14,
                                              fontWeight: !fields.taxExempt
                                                  ? FontWeight.bold
                                                  : FontWeight.w300,
                                            )),
                                        Switch(
                                            activeColor: Colors.lightBlue,
                                            value: !fields.taxExempt,
                                            focusNode: focus.taxExempt,
                                            onChanged: (_) {
                                              setState(() {
                                                fields.taxExempt = !_;
                                              });
                                            }),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
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
                                              this.setState(() {
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
                                          menuToggle = !menuToggle;
                                          if (menuToggle) {
                                            this._overlayEntry =
                                                this._createOverlayEntry();
                                            Overlay.of(context)
                                                .insert(this._overlayEntry);
                                          } else {
                                            this._overlayEntry.remove();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  controller: fields.name,
                                  obscureText: false,
                                  focusNode: focus.name,
                                  textInputAction: TextInputAction.next,
                                  style: style,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    hintText: "Product Name (e.g. Scratch)",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    errorMaxLines: 3,
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter your name';
                                    }

                                    return null;
                                  },
                                ),
                              ]))))),
                  IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        BlocProvider.of<ProductBloc>(context).add(
                            ProductEditEvent(
                                step: ProductModify.Initialize, tag: null));
                      })
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: loading ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: loading
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(color: Colors.black54),
                      child: Center(
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.white)))
                  : Container(),
            ),
          ],
        );
      }
      return Center(
          child: CircularProgressIndicator(backgroundColor: Colors.white));
    });
  }
}
