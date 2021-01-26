import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:naylors_client/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naylors_client/blocs/blocs.dart';

class ProductDetailBody extends StatelessWidget {
  final NaylorsHomePageState parent;
  final int initProduct;
  ProductDetailBody(this.parent, this.initProduct);
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
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
              .add(ProductRequested(tag: initProduct.toString()));
        }
        if (state is ProductLoadInProgress) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black38,
            ),
            child: Center(child: CircularProgressIndicator(backgroundColor: Colors.white)),
          );
        }
        if (state is ProductLoadSuccess) {
          final product = state.product;
          List<DropdownMenuItem<String>> dropdownItems =
              List<DropdownMenuItem<String>>();

          product.sizes.forEach((value) {
            dropdownItems.add(DropdownMenuItem(
              child: Text(value['size']),
              value: value['tag'].toString(),
            ));
          });

          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
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
                                BlocProvider.of<NavigatorBloc>(context)
                                    .add(NavigatorToProducts());
                              },
                              icon: Icon(Icons.arrow_back,
                                  size: 32.0, color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: FractionalOffset(1, 0.0),
                            child: Text("Tag: ${product.tag}",
                              style: style.copyWith(
                                color: Colors.blue,
                                fontSize: 14,
                                fontFamily: "Monospace",
                                backgroundColor: Colors.white)),
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
                                      blurRadius: 30.0,
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
                                color: Color(0xDDFFFFFF),
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
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
                                onChanged: (_) {
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
                          AddToCartButton(this,
                              product: product, quantity: quantity),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Divider(
                              thickness: 1, color: Colors.white, endIndent: 8)),
                      Text("DESCRIPTION",
                          style: style.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Expanded(
                          child: Divider(
                              thickness: 1, color: Colors.white, indent: 8)),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                ),
                Expanded(
                  // Tip: Use two /n/n for newlines in text.
                  child: Markdown(
                    data: product.description,
                    styleSheet: MarkdownStyleSheet(
                      p: style.copyWith(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        if (state is ProductLoadFailure) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("An Error Occurred While Loading this Product")));
          });
          BlocProvider.of<NavigatorBloc>(context).add(NavigatorToProducts());
          return Center(
            child: Icon(Icons.warning, size: 80, color: Colors.red),
          );
        }

        return Center(child: CircularProgressIndicator(backgroundColor: Colors.white));
      },
    );
  }
}
