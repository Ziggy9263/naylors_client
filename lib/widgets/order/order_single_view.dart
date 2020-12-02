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
        BlocProvider.of<OrderListBloc>(context).currentOrder = state.order;
        BlocProvider.of<OrderBloc>(context).add(OrderReset());
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          this.parent.setState(() {
            this.parent.showSnackBar(SnackBar(
                content: Text(
                    'An order for ${state.order.formattedItemList} Successfully Cancelled')));
          });
        });
      }
      if (state is OrderCancelFailure) {
        BlocProvider.of<OrderBloc>(context).add(OrderReset());
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          this.parent.setState(() {
            this.parent.showSnackBar(
                SnackBar(content: Text('Unable to Cancel Order!')));
          });
        });
      }
      if (state is OrderInitial) {
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
                              Text("Cancel"),
                            ],
                          ),
                          onPressed: () {
                            BlocProvider.of<OrderBloc>(context).add(
                                OrderCancel(uuid: orders[currentChoice].uuid));
                          },
                        ),
                        MaterialButton(
                          child: Column(
                            children: [
                              Icon(Icons.edit, color: Colors.grey),
                              Text("Edit"),
                            ],
                          ),
                          onPressed: () {
                            this.parent.setState(() {
                              this.parent.showSnackBar(
                                  SnackBar(content: Text('Edit')));
                            });
                          },
                        ),
                        MaterialButton(
                          child: Column(
                            children: [
                              Icon(Icons.redo, color: Colors.lightBlue),
                              Text("Re-Order"),
                            ],
                          ),
                          onPressed: () {
                            this.parent.setState(() {
                              this.parent.showSnackBar(SnackBar(
                                  content: Text(
                                      'Re-Order ${orders[currentChoice].formattedItemList}?')));
                            });
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
