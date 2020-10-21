import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:naylors_client/products.dart';

class CartItem {
  int product; // Referenced by tag
  int quantity;

  set _product(int p) => this.product = p;
  set _quantity(int q) => this.quantity = q;

  CartItem({this.product, this.quantity});
}

class CartDetail {
  List<CartItem> detail = List<CartItem>();
  // TODO: Use BLoC Pattern to make this easier

  void addItem(CartItem i) {
    detail.add(i);
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
            : ListView.builder(
                itemCount: cartDetail.cart.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  _incrementQuantity() {
                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                      cartDetail.cart[index]._quantity =
                          cartDetail.cart[index].quantity + 1;
                      var q = cartDetail.cart[index].quantity;
                      setState(() {
                        quantityList[index].text = (q).toString();
                      });
                    });
                  }

                  _decrementQuantity() {
                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
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
                  return Card(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: LimitedBox(
                        maxHeight: 144,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(item.product.toString()),
                            Column(
                              verticalDirection: VerticalDirection.up,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
