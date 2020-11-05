import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/widgets/widgets.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/util/util.dart';

class CartDetailCards extends StatelessWidget {
  CartBodyState parent;
  List<CartItem> cart;
  List<TextEditingController> quantityList;
  TextStyle style;

  CartDetailCards({
    @required this.parent,
    @required this.cart,
    @required this.quantityList,
    @required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: cart.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        _deleteItemFromCart() {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            this.parent.parent.setState(() {
              this.parent.setState(() {
                BlocProvider.of<CartBloc>(context)
                    .add(CartRemove(product: cart[index].product));
              });
            });
          });
        }

        _incrementQuantity() {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            cart[index].quantity = cart[index].quantity + 1;
            var q = cart[index].quantity;
            this.parent.setState(() {
              quantityList[index].text = (q).toString();
            });
          });
        }

        _setQuantity(String value) {
          if (value != null) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              this.parent.setState(() {
                cart[index].quantity = int.parse(value);
              });
            });
          } else
            return;
        }

        _decrementQuantity() {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            if (cart[index].quantity >= 2)
              cart[index].quantity = cart[index].quantity - 1;
            var q = cart[index].quantity;
            this.parent.setState(() {
              quantityList[index].text = (q).toString();
            });
          });
        }

        final item = cart[index];
        String size;
        if (item != null)
          item.detail.sizes.forEach((val) {
            if (val['tag'] == item.product.toString()) size = val['size'];
          });
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: Colors.blue[900], width: 0.5)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: LimitedBox(
              maxHeight: 144,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  /** PRODUCT DETAIL */
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints.expand(),
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(6, 6, 0, 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                item.detail.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: style.copyWith(
                                    fontWeight: FontWeight.w500, fontSize: 24),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              endIndent: 0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    QuantityIncrementalButtons(
                                      quantity: quantityList[index],
                                      style: style,
                                      onDecrement: _decrementQuantity,
                                      onIncrement: _incrementQuantity,
                                      onSubmitted: _setQuantity,
                                    ),
                                    Text("Quantity",
                                        style: style.copyWith(fontSize: 12)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text("$size",
                                        style: style.copyWith(fontSize: 20)),
                                    Text("Size",
                                        style: style.copyWith(fontSize: 12)),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        width: 1, color: Colors.blue[900]),
                                  ),
                                  padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                  margin: EdgeInsets.fromLTRB(2, 2, 6, 2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "\$${format(item.detail.price)}",
                                        style: style.copyWith(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32,
                                        ),
                                      ),
                                      Text(
                                          (item.detail.taxExempt)
                                              ? 'Tax Exempt'
                                              : '+Tax',
                                          style: style.copyWith(
                                            fontWeight: FontWeight.w300,
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
                    width: 48,
                    child: Container(
                      constraints: BoxConstraints.expand(),
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white54,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Material(
                              clipBehavior: Clip.antiAlias,
                              color: Colors.blue[600],
                              child: IconButton(
                                icon: Icon(
                                  Icons.visibility,
                                  size: 32,
                                ),
                                onPressed: () async {
                                  Navigator.pushNamed(context, '/product',
                                          arguments: item.detail)
                                      .then((value) {
                                    this.parent.setState(() {
                                      item.quantity = cart[index].quantity;
                                    });
                                  });
                                },
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Material(
                              clipBehavior: Clip.antiAlias,
                              color: Colors.red[600],
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  size: 32,
                                ),
                                onPressed: _deleteItemFromCart,
                                color: Colors.black54,
                              ),
                            ),
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
    );
  }
}
