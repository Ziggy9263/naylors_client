import 'package:equatable/equatable.dart';
import 'package:naylors_client/models/models.dart';

// ignore: must_be_immutable
class CartItem extends Equatable {
  final int product; // Referenced by tag
  int quantity;

  ProductDetail detail;

  CartItem({this.product, this.quantity, this.detail});

  @override
  List<Object> get props => [product];
}