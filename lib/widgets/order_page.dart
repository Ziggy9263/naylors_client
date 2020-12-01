import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/util/util.dart';
import 'package:naylors_client/widgets/widgets.dart';

class OrderPage extends StatefulWidget {
  final NaylorsHomePageState parent;
  OrderPage(this.parent);
  @override
  _OrderPageState createState() => _OrderPageState(parent);
}

class _OrderPageState extends State<OrderPage> {
  final NaylorsHomePageState parent;
  _OrderPageState(this.parent);
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
      if (state is OrderInitial) {
        BlocProvider.of<OrderBloc>(context).add(OrderListRequested());
      }
      if (state is OrderListLoadInProgress) {
        return Center(
            child: CircularProgressIndicator(backgroundColor: Colors.white));
      }
      if (state is OrderListEmpty) {
        return InkWell(
          onTap: () {
            BlocProvider.of<NavigatorBloc>(context).add(NavigatorToProducts());
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.keyboard_return, color: Colors.white, size: 30),
                  SizedBox(width: 8),
                  Text("No Previous Orders",
                      style: style.copyWith(color: Colors.white, fontSize: 24)),
                ],
              ),
              SizedBox(height: 24),
              Text("Tap anywhere to go back",
                  style: style.copyWith(color: Colors.white, fontSize: 14)),
            ],
          ),
        );
      }
      if (state is OrderListLoadSuccess) {
        List<OrderRes> orders = state.orderList.formattedList;
        int currentChoice = BlocProvider.of<OrderBloc>(context).currentChoice;
        OrderRes currentOrder = orders[currentChoice];
        return Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                                              Colors.white24,
                                              BlendMode.lighten),
                                          fit: BoxFit.fitWidth,
                                          alignment: FractionalOffset.center,
                                          image:
                                              AssetImage(item.detail.images[0]),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      /** PRODUCT DETAIL */
                                      Expanded(
                                        child: Container(
                                          constraints: BoxConstraints.expand(),
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              Colors.white70,
                                              Colors.white,
                                            ]),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(2, 2, 2, 2),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      2, 0, 2, 0),
                                                  child: SizedBox(
                                                    width: 40,
                                                    child: Text(
                                                        "${item.quantity}",
                                                        style: style,
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 90,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
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
                                                              style: style
                                                                  .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
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
                                                          fontWeight:
                                                              FontWeight.w300,
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
                        Expanded(child: Container()),
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
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 2, 8, 0),
                      child: Text(
                        "Previous Orders",
                        style: style.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[100]),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.white)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        (state.orderList.failedOrders > 0
                                ? null
                                : Container()) ??
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 2, 8, 0),
                              child: Tooltip(
                                message:
                                    "${state.orderList.failedOrders} Orders Previously Failed to Process",
                                child: Icon(Icons.warning,
                                    color: Colors.grey[100]),
                              ),
                            ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 2, 8, 0),
                          child: IconButton(
                            icon: Icon(Icons.refresh, color: Colors.grey[100]),
                            onPressed: () {
                              BlocProvider.of<OrderBloc>(context)
                                  .add(OrderListRequested());
                            },
                          ),
                        ),
                      ],
                    ),
                  ]),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: (index ==
                              BlocProvider.of<OrderBloc>(context).currentChoice)
                          ? Colors.lightBlue[100]
                          : Colors.white,
                      elevation: 0.5,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            BlocProvider.of<OrderBloc>(context).currentChoice =
                                index;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 2.0),
                          child: Row(
                            children: <Widget>[
                              Material(
                                color: Colors.green,
                                shape: CircleBorder(),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(8, 2, 8, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                            "Order Status: ${orders[index].recentStatus}",
                                            style: style.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Details: ",
                                            style: style.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${orders[index].formattedItemList}",
                                              style: style.copyWith(
                                                  fontSize: 16,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                          Text("Total: ",
                                              style: style.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Text(
                                            "\$${format(orders[index].total)}",
                                            style: style.copyWith(
                                                fontSize: 16,
                                                color: Colors.green),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child:
                                            Text("UUID: ${orders[index].uuid}",
                                                style: style.copyWith(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w300,
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
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
      if (state is OrderListLoadFailure) {
        Timer(new Duration(seconds: 5), () {
          BlocProvider.of<OrderBloc>(context).add(OrderListRequested());
        });
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("${state.error}",
                  style: style.copyWith(color: Colors.white)),
              SizedBox(height: 12),
              CircularProgressIndicator(backgroundColor: Colors.white),
            ],
          ),
        );
      }
      return Center(child: CircularProgressIndicator());
    });
  }
}
