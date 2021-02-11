import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

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
    return BlocBuilder<OrderListBloc, OrderListState>(
        builder: (context, state) {
      if (state is OrderListInitial) {
        BlocProvider.of<OrderListBloc>(context).add(OrderListRequested());
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
        int currentChoice =
            BlocProvider.of<OrderListBloc>(context).currentChoice;
        OrderRes currentOrder = orders[currentChoice];
        return Center(
          child: Column(
            children: [
              OrderSingleView(
                  currentOrder: currentOrder,
                  style: style,
                  parent: parent,
                  orders: orders,
                  currentChoice: currentChoice),
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
                              BlocProvider.of<OrderListBloc>(context)
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
                              BlocProvider.of<OrderListBloc>(context)
                                  .currentChoice)
                          ? Colors.lightBlue[100]
                          : Colors.white,
                      elevation: 0.5,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            BlocProvider.of<OrderListBloc>(context)
                                .currentChoice = index;
                          });
                        },
                        onLongPress: () {
                          Clipboard.setData(new ClipboardData(
                              text:
                                  "Naylor's Order UUID: ${orders[index].uuid}"));
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 2.0),
                          child: Row(
                            children: <Widget>[
                              OrderStatusIcon(
                                  status: orders[index].recentStatus),
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
          BlocProvider.of<OrderListBloc>(context).add(OrderListRequested());
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
      return Center(
          child: CircularProgressIndicator(backgroundColor: Colors.white));
    });
  }
}
