import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/widgets/widgets.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainNavDrawer(),
      body: BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
        if (state is OrderInitial) {
          BlocProvider.of<OrderBloc>(context).add(OrderListRequested());
        }
        if (state is OrderListLoadInProgress) {
          return Center(child: CircularProgressIndicator());
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
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          (state.orderList.failedOrders > 0 ? null : false) ?? Padding(
                            padding: EdgeInsets.fromLTRB(8, 2, 8, 0),
                            child: Tooltip(
                              message: "${state.orderList.failedOrders} Orders Previously Failed to Process",
                              child: Icon(Icons.warning),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 2, 8, 0),
                            child: IconButton(
                              icon:
                                  Icon(Icons.refresh, color: Colors.grey[600]),
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
                          padding: EdgeInsets.all(16.0),
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
                                  padding: EdgeInsets.fromLTRB(8, 2, 8, 8),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                            "${orders[index].recentStatus}",
                                            style: style.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            "Details: ",
                                            style: style.copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${orders[index].formattedItemList}",
                                            style: style.copyWith(
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ],
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
      }),
    );
  }
}
