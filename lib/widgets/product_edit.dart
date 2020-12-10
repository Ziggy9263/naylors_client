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

class ProductEdit extends StatelessWidget {
  final NaylorsHomePageState parent;
  final int initProduct;

  ProductEdit(this.parent, this.initProduct);

  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _formKey = GlobalKey<FormState>();
  var fields = {
    'tag': new TextEditingController(),
    'name': new TextEditingController(),
    'description': new TextEditingController(),
    'price': new TextEditingController(),
    'taxExempt': false,
    'root': false,
    'category': new TextEditingController(),
  };
  bool root = false;
  final focus = {
    'tag': new FocusNode(),
    'name': new FocusNode(),
    'description': new FocusNode(),
    'price': new FocusNode(),
    'taxExempt': new FocusNode(),
    'root': new FocusNode(),
    'category': new FocusNode(),
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        bool loading = false;
        ProductDetail product = new ProductDetail();
        if (state is ProductInitial) {
          (initProduct != null)
              ? BlocProvider.of<ProductBloc>(context).add(ProductEditEvent(
                  step: ProductModify.Initialize, tag: initProduct.toString()))
              : BlocProvider.of<ProductBloc>(context).add(
                  ProductEditEvent(step: ProductModify.Initialize, tag: null));
        }
        if (state is ProductEditInitial) {
          if (state.product != null) product = state.product;
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
                      "We're here for ${product.name}, which is a ${fields['root'] ? 'root' : 'non-root'} product in the ${product.category} category."),
                  Form(
                      key: _formKey,
                      child: Container(
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: FocusScope(
                                  child: Column(children: <Widget>[
                                TextFormField(
                                  controller: fields['tag'],
                                  obscureText: false,
                                  focusNode: focus['tag'],
                                  textInputAction: TextInputAction.next,
                                  style: style,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        10.0, 7.5, 10.0, 7.5),
                                    hintText: "Product Tag (e.g. 36009)",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
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
                                Switch(
                                    value: root,
                                    autofocus: true,
                                    focusNode: focus['root'],
                                    onChanged: (_) {
                                      this.parent.setState(() {
                                        root = _;
                                      });
                                    }),
                                TextFormField(
                                  controller: fields['name'],
                                  obscureText: false,
                                  focusNode: focus['name'],
                                  textInputAction: TextInputAction.next,
                                  style: style,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    hintText: "Product Name (e.g. Scratch)",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32.0),
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
      },
    );
  }
}
