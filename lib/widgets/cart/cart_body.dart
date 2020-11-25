import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/widgets/widgets.dart';

// ignore: must_be_immutable
class CartBody extends StatefulWidget {
  NaylorsHomePageState parent;

  @override
  CartBodyState createState() => CartBodyState(parent: this.parent);
  CartBody({Key key, @required this.parent}) : super(key: key);
}

class CartBodyState extends State<CartBody> {
  NaylorsHomePageState parent;
  CartBodyState({this.parent});
  List<TextEditingController> quantityList = List<TextEditingController>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  List<CartItem> cart;

  @override
  initState() {
    super.initState();
    cart = BlocProvider.of<CartBloc>(context).cartRepository.detail;
    cart.forEach((v) {
      quantityList.add(TextEditingController(text: v.quantity.toString()));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      if (state is CartInitial) {
        BlocProvider.of<CartBloc>(context).add(CartRequested());
      }
      if (state is CartEmpty) {
        BlocProvider.of<CartBloc>(context).add(CartRequested());
      }
      if (state is CartModificationInProgress) {
        return Container(child: Center(child: CircularProgressIndicator()));
      }
      if (state is CartNotEmpty) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: OutlinedButton(
                  onPressed: () {
                    BlocProvider.of<NavigatorBloc>(context)
                        .add(NavigatorToCart());
                    parent.setState(() => {
                          parent.headerTitle =
                              (BlocProvider.of<NavigatorBloc>(context)
                                      .cartToggle)
                                  ? "Naylor's Online: Products"
                                  : "Naylor's Online: Your Cart"
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.arrow_back,
                          size: 32.0, color: Colors.lightBlue),
                      Text("Return to Products"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: CartDetailCards(
                  parent: this,
                  cart: state.cart,
                  quantityList: quantityList,
                  style: style,
                ),
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
                      Navigator.pushNamed(context, '/checkout').then((val) {
                        setState(() {
                          BlocProvider.of<CartBloc>(context)
                              .add(CartRequested());
                        });
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return InkWell(
        onTap: () {
          parent.setState(() => {
                parent.headerTitle =
                    (BlocProvider.of<NavigatorBloc>(context).cartToggle)
                        ? "Naylor's Online: Products"
                        : "Naylor's Online: Your Cart"
              });
          BlocProvider.of<NavigatorBloc>(context).add(NavigatorToCart());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.keyboard_return, color: Colors.white, size: 30),
                SizedBox(width: 8),
                Text("Cart is Empty", style: style.copyWith(color: Colors.white, fontSize: 24)),
              ],
            ),
            SizedBox(height: 24),
            Text("Tap anywhere to go back", style: style.copyWith(color: Colors.white, fontSize: 14)),
          ],
        ),
      );
    });
  }
}
