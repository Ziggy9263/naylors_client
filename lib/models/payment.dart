import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class PaymentInfo extends Equatable {
  final String cardNumber; // Referenced by tag
  final String expiryMonth;
  final String expiryYear;
  final String cvv;
  final String avsZip;
  final String avsStreet;

  PaymentInfo(
      {this.cardNumber,
      this.expiryMonth,
      this.expiryYear,
      this.cvv,
      this.avsZip,
      this.avsStreet});

  @override
  List<Object> get props =>
      [cardNumber, expiryMonth, expiryYear, cvv, avsZip, avsStreet];
}

class PaymentHistory extends Equatable {
  final String status;
  final Object ref;
  final String ts;

  PaymentHistory({this.status, this.ref, this.ts});

  @override
  List<Object> get props => [status, ref, ts];
}
