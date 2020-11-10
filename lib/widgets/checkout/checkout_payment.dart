import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  TextEditingController expiryMonth = TextEditingController();
  TextEditingController expiryYear = TextEditingController();
  TextEditingController cvv = TextEditingController();
  TextEditingController avsZip = TextEditingController();
  TextEditingController avsStreet = TextEditingController();
  FocusNode cardNumberFocus,
      cardHolderFocus,
      expiryMonthFocus,
      expiryYearFocus,
      cvvFocus,
      avsZipFocus,
      avsStreetFocus;
  final _formKey = GlobalKey<FormState>();

  _getCardType() {
    setState(() {
      _paymentCard.type = CardUtils.getCardType(cardNumber.text);
    });
  }

  List<TextSpan> _formatErrorMsg(List<String> data) {
    List<TextSpan> lines = [];
    data.forEach((val) => {
      lines.add(TextSpan(text: val))
    });
    return lines;
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
          return Container(
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
                        Navigator.pop(context);
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
                                        width: 150,
                                        child: TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            style: style,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      10.0, 15.0, 10.0, 15.0),
                                              hintText: "01/20",
                                              labelText: "MM/YY",
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
                                                  4),
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
                            PaymentInfo paymentInfo = PaymentInfo(
                              cardNumber: cardNumber.text,
                              expiryMonth: expiryMonth.text,
                              expiryYear: expiryYear.text,
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
              ));
        }
        if (state is OrderPlaceInProgress) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is OrderPlaceSuccess) {
          return Container(child: Text("Success"));
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
                        /*(_email != null) ? "$_email" : */ "Not Logged In",
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
                    child: RichText(
                      text: TextSpan(
                        text: 'Error Dump',
                        style: style.copyWith(
                          fontFamily: 'Monospace',
                          fontSize: 12,
                        ),
                        children: _formatErrorMsg(state.lines),
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
            child: Center(child: Text("Something went wrong.")),
          ),
        );
      }),
    );
  }
}

