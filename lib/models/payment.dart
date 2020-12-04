import 'package:equatable/equatable.dart';

enum CardType { MasterCard, Visa, Discover, AmericanExpress, Others, Invalid }

class PaymentCard {
  CardType type;
  String number;
  String name;
  int month;
  int year;
  int cvv;

  PaymentCard(
      {this.type, this.number, this.name, this.month, this.year, this.cvv});
}

enum PayOption { inStore, withCard }

// ignore: must_be_immutable
class PaymentInfo extends Equatable {
  final String cardNumber; // Referenced by tag
  final String expiryMonth;
  final String expiryYear;
  final String cvv;
  final String avsZip;
  final String avsStreet;
  final PayOption payOption;

  PaymentInfo(
      {this.cardNumber,
      this.expiryMonth,
      this.expiryYear,
      this.cvv,
      this.avsZip,
      this.avsStreet,
      this.payOption});

  @override
  List<Object> get props =>
      [cardNumber, expiryMonth, expiryYear, cvv, avsZip, avsStreet, payOption];
}

class PaymentHistory extends Equatable {
  final String status;
  final Object ref;
  final String ts;

  PaymentHistory({this.status, this.ref, this.ts});

  @override
  List<Object> get props => [status, ref, ts];
}
