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

class OrderRes extends Equatable {
  final List<dynamic> cartDetail;
  final String userComments;
  final List<dynamic> payHistory;

  OrderRes({this.cartDetail, this.userComments, this.payHistory});

  factory OrderRes.fromJSON(Map<String, dynamic> json) {
    return OrderRes(
      cartDetail: json['cartDetail'],
      userComments: json['userComments'],
      payHistory: json['payHistory'],
    );
  }

  @override
  List<Object> get props => [cartDetail, userComments, payHistory];
}

class OrderListRes extends Equatable {
  final List<OrderRes> list;

  OrderListRes({this.list});

  factory OrderListRes.fromJSON(Map<String, dynamic> json) {
    json.map((m) => OrderRes.fromJSON(m))
    return OrderListRes(
      list: ,
    );
  }

  @override
  List<Object> get props => [list];
}
