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
          List<OrderRes> orders = state.orderList.list;
          return Center(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Card(
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
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text("${orders[index].recentStatus}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
