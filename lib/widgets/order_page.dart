import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/blocs/blocs.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
        if (state is OrderInitial) {
          BlocProvider.of<OrderBloc>(context).add(OrderListRequested());
        }
        if (state is OrderListLoadInProgress) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is OrderListLoadSuccess) {
          return Center(child: Text("${state.orderList}"));
        }
        if (state is OrderListLoadFailure) {
          return Center(child: Text("${state.error}"));
        }
        return Center(child: CircularProgressIndicator());
      }),
    );
  }
}
