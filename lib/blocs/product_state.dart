import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:naylors_client/models/models.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

/// Product (Singular)
class ProductInitial extends ProductState {}

class ProductLoadInProgress extends ProductState {}

class ProductLoadSuccess extends ProductState {
  final ProductDetail product;

  const ProductLoadSuccess({@required this.product}) : assert(product != null);

  @override
  List<Object> get props => [product];
}

class ProductLoadFailure extends ProductState {}

/// Product (List)
class ProductListInitial extends ProductState {}

class ProductListLoadInProgress extends ProductState {}

class ProductListLoadSuccess extends ProductState {
  final ProductList productList;

  const ProductListLoadSuccess({@required this.productList})
      : assert(productList != null);

  @override
  List<Object> get props => [productList];
}

class ProductListLoadFailure extends ProductState {}
