import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:async';

import 'package:naylors_client/widgets/widgets.dart';
import 'package:naylors_client/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naylors_client/blocs/blocs.dart';

class ProductDetailBody extends StatelessWidget {
  final ProductDetail initProduct;
  ProductDetailBody(this.initProduct);
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  Future<ProductDetail> product;
  final quantity = TextEditingController();

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 2 : 2);
  }

  onInit() {
    quantity.text = "1";
    quantity.selection = TextSelection.collapsed(offset: quantity.text.length);
    quantity.addListener(() {
      final newText = quantity.text.toLowerCase();
      quantity.value = quantity.value.copyWith(
        text: newText,
        selection: TextSelection(
            baseOffset: newText.length, extentOffset: quantity.text.length),
        composing: TextRange.empty,
      );
    });
  }

  _incrementQuantity() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      var q = int.parse(quantity.text);
      q++;
      quantity.text = (q).toString();
    });
  }

  _decrementQuantity() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      var q = int.parse(quantity.text);
      if (q >= 2) q--;
      quantity.text = (q).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    onInit();
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductInitial) {
          BlocProvider.of<ProductBloc>(context)
              .add(ProductRequested(tag: initProduct.tag));
        }
        if (state is ProductLoadInProgress) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black38,
            ),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is ProductLoadSuccess) {
          final product = state.product;
          List<DropdownMenuItem<String>> dropdownItems =
              List<DropdownMenuItem<String>>();

          product.sizes.forEach((value) {
            dropdownItems.add(DropdownMenuItem(
              child: Text(value['size']),
              value: value['tag'],
            ));
          });

          return Scaffold(
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 30.0, 0, 0),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: (product.images.isNotEmpty)
                            ? BoxDecoration(
                                color: Colors.blue,
                                image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  alignment: FractionalOffset.center,
                                  image: AssetImage(product.images[0]),
                                ),
                              )
                            : BoxDecoration(
                                color: Colors.blue,
                              ),
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: FractionalOffset(0.02, 0.0),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.arrow_back,
                                    size: 32.0, color: Colors.white),
                              ),
                            ),
                            Align(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                child: Text(
                                  product.name,
                                  textAlign: TextAlign.center,
                                  style: style.copyWith(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 12.0,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                alignment: Alignment.bottomRight,
                                padding: EdgeInsets.fromLTRB(4, 4, 2, 2),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.blue[900],
                                      width: 2,
                                    ),
                                    top: BorderSide(
                                      color: Colors.blue[900],
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "\$${format(product.price)}",
                                      style: style.copyWith(
                                        color: Colors.green[600],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Text(
                                          (product.taxExempt)
                                              ? 'Tax Exempt'
                                              : '+Tax',
                                          style: style.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 2,
                    thickness: 2,
                    color: Colors.blue[900],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: SizedBox(
                      height: 64,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              DropdownButton(
                                value: product.tag,
                                items: dropdownItems,
                                /*[
                                  /**
                                   * TODO: Create a builder for product specific sizes with links to respective tag
                                   * Requirements: API Sizes field on products in format of:
                                   *    size: [ { "label": "50lbs", "tag": "36009" }, ... ]
                                   */
                                  DropdownMenuItem(
                                      child: Text('50lbs.'), value: '36009'),
                                  DropdownMenuItem(
                                      child: Text('1 bag'), value: '12345'),
                                ],*/
                                onChanged: (_) {
                                  //_runFuture(_);
                                  BlocProvider.of<ProductBloc>(context)
                                      .add(ProductRequested(tag: _));
                                },
                              ),
                              Text('Size'),
                            ],
                          ),
                          VerticalDivider(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              QuantityIncrementalButtons(
                                quantity: quantity,
                                style: style,
                                onDecrement: _decrementQuantity,
                                onIncrement: _incrementQuantity,
                                onSubmitted: (_) => {},
                              ),
                              Text('Quantity'),
                            ],
                          ),
                          VerticalDivider(),
                          AddToCartButton(product: product, quantity: quantity),
                        ],
                      ),
                    ),
                  ),
                  Divider(thickness: 2),
                  Expanded(
                    // Tip: Use two /n/n for newlines in text.
                    child: Markdown(data: product.description),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is ProductLoadFailure) {
          return Center(
            child: Text('Something went wrong!',
                style: style.copyWith(color: Colors.red)),
          );
        }

        return Center(child: Text('???'));
      },
    );
  }
}
