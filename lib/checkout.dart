import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:naylors_client/api.dart';
import 'package:naylors_client/cart.dart';
import 'package:naylors_client/products.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  List<TextEditingController> quantityList = new List<TextEditingController>();
  String _email;

  @override
  initState() {
    super.initState();
    _loadAuthInfo();
    cartDetail.cart.forEach((v) {
      quantityList.add(TextEditingController(text: v.quantity.toString()));
    });
  }

  _loadAuthInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email');
    });
  }

  _refreshQuantities() {
    FocusScope.of(context).unfocus();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        for (int i = 0; i < quantityList.length; i++) {
          cartDetail.cart[i].quantity = int.parse(quantityList[i].text);
        }
      });
    });
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 2 : 2);
  }

  double getSubtotal() {
    double subtotal = 0;
    for (int i = 0; i < cartDetail.cart.length; i++) {
      subtotal = subtotal +
          (cartDetail.cart[i].quantity * cartDetail.cart[i].detail.price);
    }
    return subtotal;
  }

  double getTax() {
    double tax = 0;
    for (int i = 0; i < cartDetail.cart.length; i++) {
      double subtotal =
          (cartDetail.cart[i].quantity * cartDetail.cart[i].detail.price);
      tax = (tax +
          (!cartDetail.cart[i].detail.taxExempt == false
              ? subtotal * 0.0825
              : 0));
    }
    return tax;
  }

  double getTotal() {
    double total = getSubtotal() + getTax();
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      /*appBar: AppBar(
          title: Text('Naylor\'s Online Order: Checkout'),
          backgroundColor: Colors.green,
          actions: <Widget>[
            Ink(
              decoration: BoxDecoration(
                color: Colors.grey[700],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.person),
                padding: EdgeInsets.all(0),
                onPressed: () {},
              ),
            ),
          ]),*/
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.fromLTRB(0, 12, 0, 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, size: 32.0, color: Colors.black),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                child: SizedBox(
                  height: 120.0,
                  child: Image.asset(
                    "assets/logo.jpg",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                "Review Your Cart",
                style: style.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  (_email != null) ? "$_email" : "Not Logged In",
                  style: style.copyWith(
                    fontWeight: FontWeight.w300,
                    color: Colors.blueGrey,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(8),
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
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

                    _setQuantity(String value) {
                      FocusScope.of(context).unfocus();
                      if (value != null) {
                        SchedulerBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          setState(() {
                            cartDetail.cart[index].quantity = int.parse(value);
                          });
                        });
                      } else
                        return;
                    }

                    final item = cartDetail.cart[index];
                    String size;
                    item.detail.sizes.forEach((val) {
                      if (val['tag'] == item.product.toString())
                        size = val['size'];
                    });
                    return Container(
                      decoration: (item.detail.images.isNotEmpty)
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
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
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                              color: Colors.blue[100],
                            ),
                      child: LimitedBox(
                        maxHeight: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            /** PRODUCT DETAIL */
                            Expanded(
                              child: Container(
                                constraints: BoxConstraints.expand(),
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                  child: Row(
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
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(2, 0, 2, 0),
                                        child: SizedBox(
                                          width: 40,
                                          child: TextField(
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: EdgeInsets.all(0),
                                              border: OutlineInputBorder(),
                                            ),
                                            textAlign: TextAlign.right,
                                            style: style.copyWith(
                                                fontWeight: FontWeight.bold),
                                            autofocus: false,
                                            showCursor: false,
                                            controller: quantityList[index],
                                            autocorrect: true,
                                            onSubmitted: _setQuantity,
                                            onEditingComplete:
                                                _refreshQuantities,
                                            enableInteractiveSelection: false,
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
                                      ),
                                      SizedBox(
                                        width: 90,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            RichText(
                                              text: TextSpan(
                                                text:
                                                    "\$${format(item.detail.price)}",
                                                style: style.copyWith(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: "\/$size",
                                                    style: style.copyWith(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              (item.detail.taxExempt)
                                                  ? 'Tax Exempt'
                                                  : '+Tax',
                                              style: style.copyWith(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Text(
                                                  "\$${(format(item.detail.price * item.quantity))}",
                                                  style: style.copyWith(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            /** DELETE ICONBUTTON */
                            Container(
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.red[600],
                                borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(6),
                                ),
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.red[100],
                                    Colors.red[600],
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment(0.8, 0.0),
                                  tileMode: TileMode.clamp,
                                ),
                              ),
                              child: SizedBox(
                                height: 70,
                                child: Center(
                                  child: IconButton(
                                    color: Colors.black87,
                                    icon: Icon(Icons.delete),
                                    onPressed: _deleteItemFromCart,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                        text: "Subtotal: ",
                        style: style.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "\$${format(getSubtotal())}",
                            style: style.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Tax: ",
                        style: style.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "\$${format(getTax())}",
                            style: style.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*RichText(
                      text: TextSpan(
                        text: "Total: ",
                        style: style.copyWith(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "\$${format(getTotal())}",
                            style: style.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                        ],
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width - 44,
                height: 64,
                margin: EdgeInsets.fromLTRB(0, 2, 0, 4),
                child: RaisedButton(
                  child: Text(
                    "Pay \$${format(getTotal())}",
                    style: style.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                  ),
                  color: Colors.green,
                  splashColor: Colors.lightGreenAccent,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  onPressed: () {
                    _refreshQuantities();
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
