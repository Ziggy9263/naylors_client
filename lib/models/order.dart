import 'package:equatable/equatable.dart';
import 'package:naylors_client/models/models.dart';

class OrderReq extends Equatable {
  final List<CartItem> cartDetail; // Referenced by tag
  final String userComments;
  final PaymentInfo paymentInfo;

  OrderReq({this.cartDetail, this.userComments, this.paymentInfo});

  @override
  List<Object> get props => [cartDetail, userComments, paymentInfo];
}

class PayHistoryRef extends Equatable {
  final String created;
  final String paymentToken;
  final int id;
  final double amount;
  final String authCode;

  PayHistoryRef(
      {this.created, this.paymentToken, this.id, this.amount, this.authCode});

  factory PayHistoryRef.fromMap(Map<String, dynamic> ref) {
    print("$ref ||| ${ref.runtimeType}");
    return PayHistoryRef(
      created: ref['created'],
      paymentToken: ref['paymentToken'],
      id: ref['id'],
      amount: ref['amount'],
      authCode: ref['authCode'],
    );
  }

  @override
  List<Object> get props => [created, paymentToken, id, amount, authCode];
}

class PayHistory extends Equatable {
  final String status;
  final DateTime ts;
  final PayHistoryRef ref;

  PayHistory({this.status, this.ts, this.ref}) : assert(status != null);

  factory PayHistory.fromMap(Map<String, dynamic> payHistory) {
    return PayHistory(
      status: payHistory['status'],
      ts: DateTime.parse(payHistory['ts']),
      ref: (payHistory['ref'] == null)
          ? null
          : PayHistoryRef.fromMap(payHistory['_ref']),
    );
  }

  @override
  List<Object> get props => [status, ts, ref];
}

// ignore: must_be_immutable
class OrderRes extends Equatable {
  List<CartItem> cartDetail;
  final String userId;
  final String userComments;
  final List<PayHistory> payHistory;
  final String uuid;
  final DateTime createdAt;
  final DateTime updatedLast;

  OrderRes(
      {this.cartDetail,
      this.userId,
      this.userComments,
      this.payHistory,
      this.uuid,
      this.createdAt,
      this.updatedLast});

  factory OrderRes.fromJSON(Map<String, dynamic> json) {
    List<CartItem> cart = new List<CartItem>.empty(growable: true);
    List<PayHistory> payments = new List<PayHistory>.empty(growable: true);
    json['payHistory'].forEach((value) {
      payments.add(PayHistory.fromMap(value));
    });
    json['cartDetail'].forEach((value) {
      cart.add(CartItem.fromMap(value));
    });
    return OrderRes(
        cartDetail: cart,
        userId: json['user'],
        userComments: json['userComments'],
        payHistory: payments,
        uuid: json['uuid'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedLast: DateTime.parse(json['updatedLast']));
  }

  List<String> get itemList {
    List<String> items = new List<String>.empty(growable: true);
    cartDetail.forEach((value) {
      items.add(value.detail.name);
    });
    return items;
  }

  String get formattedItemList {
    List<String> items = this.itemList;
    for (int i = 0; i < items.length; i++) {
      items[i] = cartDetail[i].quantity.toString() + " " + items[i];
    }
    return items.join(", ");
  }

  double get subtotal {
    double subtotal = 0;
    for (int i = 0; i < cartDetail.length; i++) {
      subtotal =
          subtotal + (cartDetail[i].quantity * cartDetail[i].detail.price);
    }
    return subtotal;
  }

  double get tax {
    double tax = 0;
    for (int i = 0; i < cartDetail.length; i++) {
      double subtotal = (cartDetail[i].quantity * cartDetail[i].detail.price);
      tax = (tax + (!cartDetail[i].detail.taxExempt ? subtotal * 0.0825 : 0));
    }
    return tax;
  }

  double get total {
    return this.subtotal + this.tax;
  }

  String get recentStatus {
    return this.payHistory[this.payHistory.length - 1].status;
  }

  @override
  List<Object> get props => [cartDetail, userComments, payHistory];
}

// ignore: must_be_immutable
class OrderListRes extends Equatable {
  List<OrderRes> list;
  int failedOrders;

  OrderListRes({this.list});

  factory OrderListRes.fromJSON(List<dynamic> json) {
    List<OrderRes> orders = List<OrderRes>.empty(growable: true);
    json.forEach((dynamic value) {
      orders.add(OrderRes.fromJSON(value));
    });
    return OrderListRes(
      list: orders,
    );
  }

  List<OrderRes> get formattedList {
    List<OrderRes> orders = List<OrderRes>.empty(growable: true);
    failedOrders = 0;
    this.list.forEach((value) {
      if (value.recentStatus == "Placed") {
        orders.add(value);
      } else if (value.recentStatus == "Completed") {
        orders.add(value);
      } else if (value.recentStatus == "Cancelled") {
        orders.add(value);
      } else {
        failedOrders += 1;
      }
    });
    return orders;
  }

  @override
  List<Object> get props => [list];
}
