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
  final String ts;
  final PayHistoryRef ref;

  PayHistory({this.status, this.ts, this.ref}) : assert(status != null);

  factory PayHistory.fromMap(Map<String, dynamic> payHistory) {
    return PayHistory(
      status: payHistory['status'],
      ts: payHistory['ts'],
      ref: (payHistory['ref'] == null)
          ? null
          : PayHistoryRef.fromMap(payHistory['_ref']),
    );
  }

  @override
  List<Object> get props => [status, ts, ref];
}

class OrderRes extends Equatable {
  final List<dynamic> cartDetail;
  final String userComments;
  final List<PayHistory> payHistory;

  OrderRes({this.cartDetail, this.userComments, this.payHistory});

  factory OrderRes.fromJSON(Map<String, dynamic> json) {
    List<PayHistory> payments = new List<PayHistory>();
    json['payHistory'].forEach((value) {
      payments.add(PayHistory.fromMap(value));
    });
    return OrderRes(
      cartDetail: json['cartDetail'],
      userComments: json['userComments'],
      payHistory: payments,
    );
  }

  String get recentStatus {
    return this.payHistory[this.payHistory.length - 1].status;
  }

  @override
  List<Object> get props => [cartDetail, userComments, payHistory];
}

class OrderListRes extends Equatable {
  final List<OrderRes> list;

  OrderListRes({this.list});

  factory OrderListRes.fromJSON(List<dynamic> json) {
    List<OrderRes> orders = List<OrderRes>();
    json.forEach((dynamic value) {
      orders.add(OrderRes.fromJSON(value));
    });
    return OrderListRes(
      list: orders,
    );
  }

  @override
  List<Object> get props => [list];
}
