import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/widgets/widgets.dart';
import 'package:naylors_client/util/util.dart';

class CheckoutPayment extends StatefulWidget {
  final List<CartItem> cart;
  CheckoutPayment({
    Key key,
    @required this.cart,
  });

  @override
  _CheckoutPaymentState createState() => _CheckoutPaymentState(cart: cart);
}

class _CheckoutPaymentState extends State<CheckoutPayment> {
  _CheckoutPaymentState({
    @required this.cart,
  });

  final List<CartItem> cart;

  OrderReq order;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  PaymentCard _paymentCard = PaymentCard();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardHolder = TextEditingController();
  TextEditingController expiration = TextEditingController();
  TextEditingController cvv = TextEditingController();
  TextEditingController avsZip = TextEditingController();
  TextEditingController avsStreet = TextEditingController();
  FocusNode cardNumberFocus,
      cardHolderFocus,
      expirationFocus,
      cvvFocus,
      avsZipFocus,
      avsStreetFocus;
  final _formKey = GlobalKey<FormState>();

  _getCardType() {
    setState(() {
      _paymentCard.type = CardUtils.getCardType(cardNumber.text);
    });
  }

  @override
  void initState() {
    super.initState();
    _paymentCard.type = CardType.Others;
    cardNumber.addListener(_getCardType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
        if (state is OrderInitial) {
          return WillPopScope(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.fromLTRB(0, 12, 0, 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      onPressed: () {
                        BlocProvider.of<NavigatorBloc>(context)
                            .add(NavigatorToCheckout());
                      },
                      icon: Icon(Icons.arrow_back,
                          size: 32.0, color: Colors.black),
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
                      "Provide Payment Info",
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
                        /*(_email != null) ? "$_email" : */ "Not Logged In",
                        style: style.copyWith(
                          fontWeight: FontWeight.w300,
                          color: Colors.blueGrey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Form(
                        key: _formKey,
                        child: FocusScope(
                          child: ListView(
                            children: <Widget>[
                              Column(mainAxisSize: MainAxisSize.max, children: [
                                TextFormField(
                                  controller: cardNumber,
                                  obscureText: false,
                                  focusNode: cardNumberFocus,
                                  textInputAction: TextInputAction.next,
                                  style: style,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      hintText: "XXXX XXXX XXXX XXXX",
                                      labelText: "Card Number",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      icon: CardUtils.getCardIcon(
                                          _paymentCard.type)),
                                  onSaved: (_) => _paymentCard.number =
                                      CardUtils.getCleanedNumber(_),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    new LengthLimitingTextInputFormatter(24),
                                    CardNumberInputFormatter(),
                                  ],
                                  validator: CardUtils.validateCardNumber,
                                ),
                                SizedBox(height: 12),
                                TextFormField(
                                  controller: cardHolder,
                                  obscureText: false,
                                  focusNode: cardHolderFocus,
                                  textInputAction: TextInputAction.next,
                                  style: style,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    hintText: "Zane Grey",
                                    labelText: "Name on Card",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  onSaved: (_) => _paymentCard.name = _,
                                  validator: (String value) => value.isEmpty
                                      ? CardStrings.fieldReq
                                      : null,
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    SizedBox(
                                        width: 160,
                                        child: TextFormField(
                                            controller: expiration,
                                            focusNode: expirationFocus,
                                            textInputAction:
                                                TextInputAction.next,
                                            style: style,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      10.0, 15.0, 10.0, 15.0),
                                              hintText: "02/2020",
                                              labelText: "MM/YYYY",
                                              errorMaxLines: 2,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              icon: Image.asset(
                                                'assets/calendar.png',
                                                width: 40.0,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            validator: CardUtils.validateDate,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                              decimal: false,
                                              signed: false,
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              new LengthLimitingTextInputFormatter(
                                                  6),
                                              new CardMonthInputFormatter(),
                                            ],
                                            onSaved: (value) {
                                              List<int> expiryDate =
                                                  CardUtils.getExpiryDate(
                                                      value);
                                              _paymentCard.month =
                                                  expiryDate[0];
                                              _paymentCard.year = expiryDate[1];
                                            })),
                                    SizedBox(
                                      width: 150,
                                      child: TextFormField(
                                        controller: cvv,
                                        obscureText: false,
                                        focusNode: cvvFocus,
                                        textInputAction: TextInputAction.next,
                                        style: style,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 15.0, 20.0, 15.0),
                                          hintText: "123",
                                          labelText: "CVV",
                                          errorMaxLines: 2,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          icon: new Image.asset(
                                            'assets/card_cvv.png',
                                            width: 50.0,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        onSaved: (_) =>
                                            _paymentCard.cvv = int.parse(_),
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
                                  ],
                                ),
                                SizedBox(height: 12),
                                TextFormField(
                                  // TODO: Validate address
                                  controller: avsStreet,
                                  obscureText: false,
                                  focusNode: avsStreetFocus,
                                  textInputAction: TextInputAction.next,
                                  style: style,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    hintText: "102 Old Robstown Rd.",
                                    labelText: "Billing Address",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                TextFormField(
                                  // TODO: Validate Zip code
                                  controller: avsZip,
                                  obscureText: false,
                                  focusNode: avsZipFocus,
                                  textInputAction: TextInputAction.done,
                                  style: style,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    hintText: "78408",
                                    labelText: "Zip Code",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: false,
                                    signed: false,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ]),
                            ],
                          ),
                        ),
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
                              child: Text(
                                "PAY",
                                textAlign: TextAlign.center,
                                style: style.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
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
                              "\$${format(getTotal(cart))}",
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
                          if (_formKey.currentState.validate()) {
                            List<int> expiryDate =
                                CardUtils.getExpiryDate(expiration.text);
                            PaymentInfo paymentInfo = new PaymentInfo(
                              cardNumber:
                                  _paymentCard.number ?? cardNumber.text,
                              expiryMonth: expiryDate[0].toString(),
                              expiryYear: expiryDate[1].toString(),
                              cvv: cvv.text,
                              avsStreet: avsStreet.text,
                              avsZip: avsZip.text,
                            );
                            SchedulerBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              setState(() {
                                BlocProvider.of<OrderBloc>(context)
                                    .add(OrderPlaced(
                                  order: OrderReq(
                                    cartDetail: cart,
                                    userComments: cardHolder.text,
                                    paymentInfo: paymentInfo,
                                  ),
                                ));
                              });
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onWillPop: () {
              BlocProvider.of<NavigatorBloc>(context)
                  .add(NavigatorToCheckout());
              return Future.value(false);
            },
          );
        }
        if (state is OrderPlaceInProgress) {
          return Center(child: CircularProgressIndicator(backgroundColor: Colors.white));
        }
        if (state is OrderPlaceSuccess) {
          BlocProvider.of<CartBloc>(context).add(CartClear());
          return WillPopScope(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: SizedBox()),
                    Material(
                      elevation: 0,
                      shape: CircleBorder(),
                      color: Colors.lightGreen[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Material(
                          elevation: 0,
                          shape: CircleBorder(),
                          color: Colors.lightGreen,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(
                              Icons.check_circle,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text("Your Order Has Been Placed!",
                        style: style.copyWith(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                    SizedBox(height: 25),
                    Text(
                      "Check your Orders page for updates on your order.",
                      style: style.copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text("Your order should be prepared shortly."),
                    Expanded(child: SizedBox()),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 44,
                        height: 64,
                        margin: EdgeInsets.fromLTRB(0, 2, 0, 10),
                        child: RaisedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "CHECK ORDER PROGRESS",
                                  textAlign: TextAlign.center,
                                  style: style.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Icon(Icons.arrow_right,
                                  color: Colors.white, size: 40)
                            ],
                          ),
                          color: Colors.green,
                          splashColor: Colors.redAccent,
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          onPressed: () =>
                              BlocProvider.of<NavigatorBloc>(context)
                                  .add(NavigatorToOrders()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onWillPop: () async {
              BlocProvider.of<OrderBloc>(context).add(OrderReset());
              BlocProvider.of<NavigatorBloc>(context)
                  .add(NavigatorToCheckout());
              return false;
            },
          );
        }
        if (state is OrderPlaceFailure) {
          return WillPopScope(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.fromLTRB(0, 12, 0, 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      onPressed: () {
                        BlocProvider.of<OrderBloc>(context).add(OrderReset());
                      },
                      icon: Icon(Icons.arrow_back,
                          size: 32.0, color: Colors.black),
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
                      "Provide Payment Info",
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
                        BlocProvider.of<AuthBloc>(context).email ??
                            "Not Available",
                        style: style.copyWith(
                          fontWeight: FontWeight.w300,
                          color: Colors.blueGrey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Something Went Wrong!",
                    style: style.copyWith(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Markdown(
                        padding: EdgeInsets.zero,
                        data: "${state.formatted}",
                        shrinkWrap: true,
                        styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              fontFamily: 'Monospace',
                              fontSize: 10,
                            ),
                            blockquote: TextStyle(
                              fontFamily: 'Monospace',
                              fontSize: 10,
                            )),
                        extensionSet: md.ExtensionSet(
                            md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                            md.ExtensionSet.gitHubFlavored.inlineSyntaxes),
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
                              child: Text(
                                "GO BACK",
                                textAlign: TextAlign.center,
                                style: style.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        color: Colors.red,
                        splashColor: Colors.redAccent,
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        onPressed: () => BlocProvider.of<OrderBloc>(context)
                            .add(OrderReset()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onWillPop: () async {
              BlocProvider.of<OrderBloc>(context).add(OrderReset());
              return false;
            },
          );
        }
        return Container(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Center(child: CircularProgressIndicator(backgroundColor: Colors.white)),
          ),
        );
      }),
    );
  }
}
