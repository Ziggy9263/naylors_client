import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:naylors_client/api.dart';
import 'package:naylors_client/cart.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/*
    TODO: Double check cart and add "X items in cart" somewhere near the entries
    and also on the product detail. Product detail quantity buttons could represent
    and modify what is currently in the cart.
  */

class ProductsBody extends StatefulWidget {
  @override
  _ProductsBodyState createState() => _ProductsBodyState();

  ProductsBody({Key key}) : super(key: key);
}

class _ProductsBodyState extends State<ProductsBody> {
  Future<ProductList> products;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<ProductList> getProductList() async {
    return await getProducts();
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 2 : 2);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      products = getProductList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductList>(
      future: products,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // TODO: Turn this builder into a function I can use for both product and cart
          return ListView.builder(
              itemCount: snapshot.data.list.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = snapshot.data.list[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.pushNamed(context, '/product', arguments: item);
                      });
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: LimitedBox(
                          maxHeight: 64,
                          child: Row(children: <Widget>[
                            AspectRatio(
                                aspectRatio: 487 / 451,
                                child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  alignment: FractionalOffset.center,
                                  image: AssetImage((item.images.isNotEmpty)
                                      ? item.images[0]
                                      : 'no-image.png'),
                                )))),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(item.name,
                                        style: style.copyWith(
                                            fontWeight: FontWeight.w500)),
                                    Expanded(
                                      child: Align(
                                        alignment: FractionalOffset.centerLeft,
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(8, 2, 8, 2),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[400],
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Text(
                                            item.category,
                                            style: style.copyWith(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: false,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "\$${format(item.price)}",
                                    style: style.copyWith(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                    child: Text((item.taxExempt) ? '' : '+Tax',
                                        style: style.copyWith(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 12,
                                        )),
                                  ),
                                ]),
                          ])),
                    ),
                  ),
                );
              });
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        return Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 15.0),
            Text('Loading Products...'),
          ],
        ));
      },
    );
  }
}

class ProductDetailScreen extends StatefulWidget {
  final ProductDetail initProduct;
  @override
  _ProductDetailScreenState createState() =>
      _ProductDetailScreenState(this.initProduct);

  ProductDetailScreen({Key key, this.initProduct}) : super(key: key);
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductDetail initProduct;
  _ProductDetailScreenState(this.initProduct);
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  Future<ProductDetail> product;
  final quantity = TextEditingController();

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 2 : 2);
  }

  _runFuture(String tag) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      product = getProduct(tag);
      setState(() {});
    });
  }

  @override
  initState() {
    super.initState();
    product = getProduct(initProduct.tag);
    quantity.text = "1";
    quantity.selection = TextSelection.collapsed(offset: quantity.text.length);
  }

  _incrementQuantity() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      var q = int.parse(quantity.text);
      q++;
      setState(() {
        quantity.text = (q).toString();
      });
    });
  }

  _decrementQuantity() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      var q = int.parse(quantity.text);
      if (q >= 2) q--;
      setState(() {
        quantity.text = (q).toString();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    quantity.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductDetail>(
      future: product,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          List<DropdownMenuItem<String>> dropdownItems =
              List<DropdownMenuItem<String>>();

          snapshot.data.sizes.forEach((value) {
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
                        decoration: (snapshot.data.images.isNotEmpty)
                            ? BoxDecoration(
                                color: Colors.blue,
                                image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  alignment: FractionalOffset.center,
                                  image: AssetImage(snapshot.data.images[0]),
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
                                  snapshot.data.name,
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
                                      "\$${format(snapshot.data.price)}",
                                      style: style.copyWith(
                                        color: Colors.green[600],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Text(
                                          (snapshot.data.taxExempt)
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
                                value: snapshot.data.tag,
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
                                  _runFuture(_);
                                },
                              ),
                              Text('Size'),
                            ],
                          ),
                          VerticalDivider(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(Icons.remove_circle),
                                      onPressed: _decrementQuantity),
                                  SizedBox(
                                    width: 32,
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      autofocus: false,
                                      controller: quantity,
                                      autocorrect: true,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                        decimal: false,
                                        signed: false,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add_circle),
                                    onPressed: _incrementQuantity,
                                  ),
                                ],
                              ),
                              Text('Quantity'),
                            ],
                          ),
                          VerticalDivider(),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                            child: Ink(
                              decoration: const ShapeDecoration(
                                color: Colors.lightGreen,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.add_shopping_cart),
                                color: Colors.white,
                                onPressed: () {
                                  var product = int.parse(snapshot.data.tag);
                                  var _q = int.parse(quantity.text);
                                  var cartItem = CartItem(
                                      product: product,
                                      quantity: _q,
                                      detail: snapshot.data);
                                  setState(() {
                                    cartDetail.addItem(cartItem);
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(thickness: 2),
                  Expanded(
                    // Tip: Use two /n/n for newlines in text.
                    child: Markdown(data: snapshot.data.description),
                  ),
                ],
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
