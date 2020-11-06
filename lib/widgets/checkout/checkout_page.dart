import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/widgets/widgets.dart';
import 'package:naylors_client/util/util.dart';

class CheckoutPage extends StatefulWidget {
  @override
  CheckoutPageState createState() => CheckoutPageState();
}

class CheckoutPageState extends State<CheckoutPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  List<TextEditingController> quantityList = new List<TextEditingController>();
  String _email;
  List<CartItem> cart = List<CartItem>();
  OrderReq order;
  String headerTitle = "Review Your Cart";

  @override
  initState() {
    super.initState();
    _loadAuthInfo();
    cart = BlocProvider.of<CartBloc>(context).cartRepository.detail;
    cart.forEach((v) {
      quantityList.add(TextEditingController(text: v.quantity.toString()));
    });
    /*quantityList.forEach((quantity) {
      quantity.selection =
          TextSelection.collapsed(offset: quantity.text.length);
      quantity.addListener(() {
        final newText = quantity.text.toLowerCase();
        quantity.value = quantity.value.copyWith(
          text: newText,
          selection: TextSelection(
              baseOffset: newText.length, extentOffset: quantity.text.length),
          composing: TextRange.empty,
        );
      });
    });*/
  }

  _loadAuthInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email');
    });
  }

  refreshQuantities() {
    FocusScope.of(context).unfocus();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        for (int i = 0; i < quantityList.length; i++) {
          if (quantityList[i].text == "") quantityList[i].text = "0";
          int newQ = int.parse(
              (quantityList[i].text != "") ? quantityList[i].text : "0");
          cart[i].quantity = newQ;
        }
      });
    });
  }

  refreshWithFocus() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        for (int i = 0; i < quantityList.length; i++) {
          int newQ = int.parse(
              (quantityList[i].text != "") ? quantityList[i].text : "0");
          cart[i].quantity = newQ;
        }
      });
    });
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 2 : 2);
  }

  double getSubtotal() {
    double subtotal = 0;
    for (int i = 0; i < cart.length; i++) {
      subtotal = subtotal + (cart[i].quantity * cart[i].detail.price);
    }
    return subtotal;
  }

  double getTax() {
    double tax = 0;
    for (int i = 0; i < cart.length; i++) {
      double subtotal = (cart[i].quantity * cart[i].detail.price);
      tax =
          (tax + (!cart[i].detail.taxExempt == false ? subtotal * 0.0825 : 0));
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
                child: CheckoutReview(
                    cart: cart,
                    style: style,
                    quantityList: quantityList,
                    parent: this),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "CONTINUE TO",
                                style: style.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "PAYMENT",
                                style: style.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ]),
                      ),
                      VerticalDivider(
                        color: Colors.white,
                      ),
                      Text(
                        "Total: ",
                        style: style.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "\$${format(getTotal())}",
                        style: style.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  color: Colors.green,
                  splashColor: Colors.lightGreenAccent,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  onPressed: () {
                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                      setState(() {
                        Navigator.of(context)
                            .pushNamed('/payment', arguments: cart)
                            .then((_) {
                              Navigator.of(context).pop();
                            });
                      });
                    });
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
