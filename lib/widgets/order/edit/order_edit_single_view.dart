import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/scheduler.dart';

import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/util/util.dart';
import 'package:naylors_client/widgets/widgets.dart';

class OrderEditSingleView extends StatelessWidget {
  const OrderEditSingleView({
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
          // ignore: invalid_use_of_protected_member
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
        // ignore: invalid_use_of_protected_member
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          // ignore: invalid_use_of_protected_member
          this.parent.setState(() {
            this.parent.showSnackBar(SnackBar(
                content:
                    Text('Unable to Cancel Order! Reason: ${state.error}')));
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
                      itemCount: (currentOrder.recentStatus != "Cancelled")
                          ? currentOrder.cartDetail.length + 1
                          : currentOrder.cartDetail.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        bool isLast =
                            (index > currentOrder.cartDetail.length - 1);
                        CartItem item =
                            (!isLast) ? currentOrder.cartDetail[index] : null;
                        return (!isLast)
                            ? InkWell(
                                onTap: () {},
                                child: Container(
                                  decoration: (item.detail.images.isNotEmpty)
                                      ? BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
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
                                            image: NetworkImage(
                                                item.detail.images[0]),
                                          ),
                                        )
                                      : BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
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
                                            constraints:
                                                BoxConstraints.expand(),
                                            margin:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            decoration: (currentOrder
                                                        .recentStatus ==
                                                    "Cancelled")
                                                ? BoxDecoration(
                                                    gradient:
                                                        LinearGradient(colors: [
                                                      Colors.white70,
                                                      Colors.white,
                                                    ]),
                                                  )
                                                : BoxDecoration(
                                                    gradient:
                                                        LinearGradient(colors: [
                                                      Colors.white70,
                                                      Colors.white,
                                                    ]),
                                                    border: Border.all(
                                                        color: Colors.blue),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  2, 2, 2, 2),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  (currentOrder.recentStatus ==
                                                          "Cancelled")
                                                      ? Container()
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  8.0, 0, 0, 0),
                                                          child: Icon(
                                                            Icons.edit,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                  Expanded(
                                                    child: Text(
                                                      item.detail.name,
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 2,
                                                      style: style.copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
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
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: <Widget>[
                                                        RichText(
                                                          text: TextSpan(
                                                            text:
                                                                "\$${format(item.detail.price)}",
                                                            style:
                                                                style.copyWith(
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 18,
                                                            ),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                text: (item
                                                                            .detail
                                                                            .sizes
                                                                            .length >
                                                                        0)
                                                                    ? "\/${item.detail.sizes.firstWhere((element) => element['tag'] == item.product.toString())['size']}"
                                                                    : "",
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
                                                          (item.detail
                                                                  .taxExempt)
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
                                ),
                              )
                            : (currentOrder.recentStatus == "Cancelled")
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'This Feature In Development')));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
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
                                            /** ADD ITEM */
                                            Expanded(
                                              child: Container(
                                                constraints:
                                                    BoxConstraints.expand(),
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      LinearGradient(colors: [
                                                    Colors.white70,
                                                    Colors.white,
                                                  ]),
                                                  border: Border.all(
                                                    color: Colors.green,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      2, 2, 2, 2),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                8.0, 0.0, 0, 0),
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "Add an Item to This Order",
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 2,
                                                          style: style.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 16),
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
                                    ),
                                  );
                      })),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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
                            // ignore: invalid_use_of_protected_member
                            this.parent.setState(() {
                              this.parent.showSnackBar(SnackBar(
                                  content: Text(
                                      'This Feature Is Not Available Yet!')));
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

class EditOrderItemDialog extends StatefulWidget {
  final CartItem item;
  final TextStyle style;
  EditOrderItemDialog({@required this.item, @required this.style});
  @override
  _EditOrderItemDialogState createState() =>
      _EditOrderItemDialogState(item: item, style: style);
}

class _EditOrderItemDialogState extends State<EditOrderItemDialog> {
  final CartItem item;
  final TextStyle style;
  _EditOrderItemDialogState({@required this.item, @required this.style});

  TextEditingController quantityController;
  CartItem editedItem;

  @override
  initState() {
    super.initState();
    editedItem = item;
    quantityController =
        new TextEditingController(text: editedItem.quantity.toString());
  }

  @override
  dispose() {
    super.dispose();
    quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.4,
        height: MediaQuery.of(context).size.height / 2.8,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 1.4,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                shape: BoxShape.rectangle,
                borderRadius: new BorderRadius.vertical(
                  top: Radius.circular(4.0),
                  bottom: Radius.zero,
                ),
              ),
              child: Text("Edit Order Item",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            Divider(
              height: 4,
              color: Colors.lightBlue,
            ),
            Expanded(
                child: Column(children: <Widget>[
              Text(item.detail.name),
              QuantityIncrementalButtons(
                  quantity: quantityController,
                  style: style,
                  onDecrement: () {
                    editedItem.quantity -= 1;
                  },
                  onIncrement: () {
                    editedItem.quantity += 1;
                  },
                  onSubmitted: (_) {
                    editedItem.quantity = int.parse(_);
                  })
            ])),
            Divider(
              height: 4,
              color: Colors.lightBlue,
            ),
            Center(
              child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green)),
                  child:
                      Text("Done", style: style.copyWith(color: Colors.white)),
                  onPressed: () {
                    /*SchedulerBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          // ignore: invalid_use_of_protected_member
                          this.parent.setState(() {
                            for (int i = 0;
                                i < orders[currentChoice].cartDetail.length;
                                i++) {
                              CartItem item =
                                  orders[currentChoice].cartDetail[i];
                              cart.cartRepository.modify(item);
                              cart.add(CartRequested());
                            }
                          });
                        });*/
                    Navigator.of(context).pop();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
