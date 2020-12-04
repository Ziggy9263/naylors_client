import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/scheduler.dart';

import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/util/util.dart';
import 'package:naylors_client/widgets/widgets.dart';

class OrderSingleView extends StatelessWidget {
  const OrderSingleView({
    Key key,
    @required this.currentOrder,
    @required this.style,
    @required this.parent,
    @required this.orders,
    @required this.currentChoice,
  }) : super(key: key);

  final OrderRes currentOrder;
  final TextStyle style;
  final NaylorsHomePageState parent;
  final List<OrderRes> orders;
  final int currentChoice;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
      if (state is OrderLoadInProgress) {
        return Container(
          padding: EdgeInsets.all(4),
          width: MediaQuery.of(context).size.width,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      if (state is OrderCancelSuccess) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          this.parent.setState(() {
            this.parent.showSnackBar(SnackBar(
                content: Text(
                    'An order for ${state.order.formattedItemList} Successfully Cancelled')));
          });
        });
        BlocProvider.of<OrderListBloc>(context).currentOrder = state.order;
        print('${BlocProvider.of<OrderListBloc>(context).currentOrder}');
        BlocProvider.of<OrderBloc>(context).add(OrderReset());
      }
      if (state is OrderCancelFailure) {
        BlocProvider.of<OrderBloc>(context).add(OrderReset());
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          this.parent.setState(() {
            this.parent.showSnackBar(SnackBar(
                content:
                    Text('Unable to Cancel Order! Reason: ${state.error}')));
          });
        });
      }
      if (state is OrderInitial) {
        CartBloc cart = BlocProvider.of<CartBloc>(context);
        return Container(
          padding: EdgeInsets.all(4),
          width: MediaQuery.of(context).size.width,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(4),
                child: Text("Status: ${currentOrder.recentStatus}",
                    style: style.copyWith(fontSize: 24)),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: currentOrder.cartDetail.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        CartItem item = currentOrder.cartDetail[index];
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
                            maxHeight: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                /** PRODUCT DETAIL */
                                Expanded(
                                  child: Container(
                                    constraints: BoxConstraints.expand(),
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Colors.white70,
                                        Colors.white,
                                      ]),
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
                                              child: Text("${item.quantity}",
                                                  style: style,
                                                  textAlign: TextAlign.center),
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18,
                                                    ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text:
                                                            "\/${item.detail.sizes.firstWhere((element) => element['tag'] == item.product.toString())['size']}",
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
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    child: Row(
                      children: <Widget>[
                        MaterialButton(
                          child: Column(
                            children: [
                              Icon(Icons.cancel, color: Colors.red),
                              Text("Cancel",
                                  style: style.copyWith(
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                          onPressed: () {
                            bool alreadyCancelled =
                                (currentOrder.recentStatus == "Cancelled");
                            if (!alreadyCancelled) {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                BlocProvider.of<OrderBloc>(context).add(
                                    OrderCancel(
                                        uuid: orders[currentChoice].uuid));
                              });
                            } else
                              this.parent.showSnackBar(SnackBar(
                                  content: Text(
                                      "This order has already been cancelled.")));
                          },
                        ),
                        MaterialButton(
                          child: Column(
                            children: [
                              Icon(Icons.edit, color: Colors.grey[200]),
                              Text("Edit",
                                  style: style.copyWith(
                                      fontSize: 16, color: Colors.grey[200])),
                            ],
                          ),
                          onPressed: () {
                            this.parent.setState(() {
                              this.parent.showSnackBar(SnackBar(
                                  content: Text(
                                      'This Feature Is Not Available Yet!')));
                            });
                          },
                        ),
                        MaterialButton(
                          child: Column(
                            children: [
                              Icon(Icons.redo, color: Colors.lightBlue),
                              Text("Re-Order",
                                  style: style.copyWith(
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.4,
                                    height: MediaQuery.of(context).size.height /
                                        2.8,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: const Color(0xFFFFFF),
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(32.0)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.4,
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: Colors.lightBlue,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                new BorderRadius.vertical(
                                              top: Radius.circular(4.0),
                                              bottom: Radius.zero,
                                            ),
                                          ),
                                          child: Text(
                                              "Re-Order Previous Items?",
                                              textAlign: TextAlign.center,
                                              style: style.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Divider(
                                          height: 4,
                                          color: Colors.lightBlue,
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                              itemCount: orders[currentChoice]
                                                  .cartDetail
                                                  .length,
                                              itemBuilder: (context, index) {
                                                CartItem item =
                                                    orders[currentChoice]
                                                        .cartDetail[index];
                                                return Container(
                                                  padding: EdgeInsets.all(4.0),
                                                  decoration: BoxDecoration(
                                                    color: (index % 2 == 1)
                                                        ? Colors.lightBlue[100]
                                                        : Colors.white,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        "${item.quantity}",
                                                        style: style.copyWith(
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${item.detail.name}",
                                                        style: style.copyWith(
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ),
                                        Divider(
                                          height: 4,
                                          color: Colors.lightBlue,
                                        ),
                                        Center(
                                            child: Text(
                                                "Add this list to your cart?")),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            FlatButton(
                                                color: Colors.green,
                                                child: Text("Yes",
                                                    style: style.copyWith(
                                                        color: Colors.white)),
                                                onPressed: () {
                                                  SchedulerBinding.instance
                                                      .addPostFrameCallback(
                                                          (timeStamp) {
                                                    this.parent.setState(() {
                                                      for (int i = 0;
                                                          i <
                                                              orders[currentChoice]
                                                                  .cartDetail
                                                                  .length;
                                                          i++) {
                                                        CartItem item = orders[
                                                                currentChoice]
                                                            .cartDetail[i];
                                                        cart.cartRepository
                                                            .modify(item);
                                                        cart.add(
                                                            CartRequested());
                                                      }
                                                    });
                                                  });
                                                  Navigator.of(context).pop();
                                                }),
                                            FlatButton(
                                                color: Colors.red,
                                                child: Text("No",
                                                    style: style.copyWith(
                                                        color: Colors.white)),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  )),
                  Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text("Tax: ",
                                  style: style.copyWith(fontSize: 16)),
                              Text("\$${format(currentOrder.tax)}",
                                  style: style.copyWith(
                                      fontSize: 20, color: Colors.green)),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text("Total: ",
                                  style: style.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(
                                "\$${format(currentOrder.total)}",
                                style: style.copyWith(
                                    fontSize: 24,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                      ])),
                ],
              ),
            ],
          ),
        );
      }
      return Container(
        padding: EdgeInsets.all(4),
        width: MediaQuery.of(context).size.width,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(child: CircularProgressIndicator()),
      );
    });
  }
}
