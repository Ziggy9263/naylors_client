import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/util/util.dart';
import 'package:naylors_client/widgets/widgets.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
      if (state is OrderInitial) {
        BlocProvider.of<OrderBloc>(context).add(OrderListRequested());
      }
      if (state is OrderListLoadInProgress) {
        return Center(child: CircularProgressIndicator());
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
                  Text("No Previous Orders", style: style.copyWith(color: Colors.white, fontSize: 24)),
                ],
              ),
              SizedBox(height: 24),
              Text("Tap anywhere to go back", style: style.copyWith(color: Colors.white, fontSize: 14)),
            ],
          ),
        );
      }
      if (state is OrderListLoadSuccess) {
        List<OrderRes> orders = state.orderList.formattedList;
        return Center(
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 2, 8, 0),
                      child: Text(
                        "${state.orderList.list.length}",
                        style: style.copyWith(
                          fontSize: 12,
                          color: Colors.grey[100],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        (state.orderList.failedOrders > 0 ? null : Container()) ??
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
                            icon: Icon(Icons.refresh, color: Colors.grey[600]),
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
                      elevation: 0.5,
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
                                      child: Text("UUID: ${orders[index].uuid}",
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
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
      if (state is OrderListLoadFailure) {
        return Center(child: Text("${state.error}"));
      }
      return Center(child: CircularProgressIndicator());
    });
  }
}
