import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:naylors_client/products.dart';
import 'package:naylors_client/api.dart';

class CartItem {
  int product; // Referenced by tag
  int quantity;

  ProductDetail detail;

  set _product(int p) => this.product = p;
  set _quantity(int q) => this.quantity = q;

  CartItem({this.product, this.quantity, this.detail});
}

class CartDetail {
  List<CartItem> detail = List<CartItem>();
  // TODO: Use BLoC Pattern to make this easier

  void addItem(CartItem i) {
    bool done = false;
    for (int index = 0; index < detail.length; index++) {
      if (detail[index].product == i.product) {
        detail[index].quantity = detail[index].quantity + i.quantity;
        done = true;
      }
    }
    if (!done) detail.add(i);
  }

  void removeItem(CartItem i) {
    detail.removeWhere((element) => (element.product == i.product));
  }

  void removeTag(String tag) {
    detail.removeWhere((element) => (element.product == int.parse(tag)));
  }

  List<CartItem> get cart {
    return detail;
  }

  CartDetail();
}

CartDetail cartDetail = new CartDetail();

class CartBody extends StatefulWidget {
  @override
  _CartBodyState createState() => _CartBodyState();
  CartBody({Key key}) : super(key: key);
}

class _CartBodyState extends State<CartBody> {
  List<TextEditingController> quantityList = List<TextEditingController>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 2 : 2);
  }

  @override
  initState() {
    super.initState();
    cartDetail.cart.forEach((v) {
      quantityList.add(TextEditingController(text: v.quantity.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: (cartDetail.cart.isEmpty)
            ? Center(child: Text('Nothing in your cart yet.'))
            : Stack(
                children: <Widget>[
                  ListView.builder(
                    itemCount: cartDetail.cart.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      _deleteItemFromCart() {
                        SchedulerBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          setState(() {
                            cartDetail.cart.removeAt(index);
                          });
                        });
                      }

                      _incrementQuantity() {
                        SchedulerBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          cartDetail.cart[index]._quantity =
                              cartDetail.cart[index].quantity + 1;
                          var q = cartDetail.cart[index].quantity;
                          setState(() {
                            quantityList[index].text = (q).toString();
                          });
                        });
                      }

                      _setQuantity(String value) {
                        if (value != null) {
                          SchedulerBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            setState(() {
                              cartDetail.cart[index].quantity =
                                  int.parse(value);
                            });
                          });
                        } else
                          return;
                      }

                      _decrementQuantity() {
                        SchedulerBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          if (cartDetail.cart[index].quantity >= 2)
                            cartDetail.cart[index]._quantity =
                                cartDetail.cart[index].quantity - 1;
                          var q = cartDetail.cart[index].quantity;
                          setState(() {
                            quantityList[index].text = (q).toString();
                          });
                        });
                      }

                      final item = cartDetail.cart[index];
                      String size;
                      item.detail.sizes.forEach((val) {
                        if (val['tag'] == item.product.toString())
                          size = val['size'];
                      });
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(
                                color: Colors.blue[900], width: 0.5)),
                        child: Container(
                          decoration: (item.detail.images.isNotEmpty)
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.blue,
                                  image: DecorationImage(
                                    colorFilter: ColorFilter.mode(
                                        Colors.white24, BlendMode.lighten),
                                    fit: BoxFit.fitWidth,
                                    alignment: FractionalOffset.center,
                                    image: AssetImage(item.detail.images[0]),
                                  ),
                                )
                              : BoxDecoration(
                                  color: Colors.blue[100],
                                ),
                          child: LimitedBox(
                            maxHeight: 144,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                /** QUANTITY INCREMENT BUTTONS */
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 1, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white54,
                                  ),
                                  child: SizedBox(
                                    width: 50,
                                    child: Column(
                                      verticalDirection: VerticalDirection.up,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.remove_circle),
                                          onPressed: _decrementQuantity,
                                        ),
                                        SizedBox(
                                          width: 32,
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            autofocus: false,
                                            controller: quantityList[index],
                                            autocorrect: true,
                                            onSubmitted: _setQuantity,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                              decimal: false,
                                              signed: false,
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.add_circle),
                                          onPressed: _incrementQuantity,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                /** PRODUCT DETAIL */
                                Expanded(
                                  child: Container(
                                    constraints: BoxConstraints.expand(),
                                    margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.white54,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(6, 6, 6, 2),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              item.detail.name,
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              style: style.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 24),
                                            ),
                                          ),
                                          Divider(thickness: 1),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Size: $size"),
                                              Container(
                                                alignment:
                                                    Alignment.bottomRight,
                                                width: 120,
                                                decoration: BoxDecoration(
                                                  color: Colors.white70,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.blue[900]),
                                                ),
                                                padding: EdgeInsets.fromLTRB(
                                                    2, 2, 2, 2),
                                                margin: EdgeInsets.fromLTRB(
                                                    2, 2, 2, 2),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    Text(
                                                      "\$${format(item.detail.price)}",
                                                      style: style.copyWith(
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 32,
                                                      ),
                                                    ),
                                                    Text(
                                                        (item.detail.taxExempt)
                                                            ? 'Tax Exempt'
                                                            : '+Tax',
                                                        style: style.copyWith(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 12,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                /** VIEW AND DELETE ICONBUTTONS */
                                SizedBox(
                                  width: 36,
                                  child: Container(
                                    constraints: BoxConstraints.expand(),
                                    margin: EdgeInsets.fromLTRB(1, 0, 0, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.white54,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.visibility),
                                          onPressed: () async {
                                            Navigator.pushNamed(
                                                    context, '/product',
                                                    arguments: await getProduct(
                                                        item.product
                                                            .toString()))
                                                .then((value) {
                                              setState(() {
                                                item.quantity = cartDetail
                                                    .cart[index].quantity;
                                              });
                                            });
                                          },
                                        ),
                                        const Divider(thickness: 1),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: _deleteItemFromCart,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  /** CHECKOUT BUTTON */
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 275,
                      height: 64,
                      margin: EdgeInsets.fromLTRB(0, 2, 0, 4),
                      child: RaisedButton(
                        child: Text("Checkout",
                            style: style.copyWith(
                              fontSize: 24,
                              color: Colors.white,
                            )),
                        color: Colors.green,
                        splashColor: Colors.lightGreenAccent,
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        onPressed: () {
                          Navigator.pushNamed(context, '/checkout');
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
