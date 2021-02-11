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

class ProductLoadFailure extends ProductState {
  final dynamic error;

  const ProductLoadFailure({@required this.error}) : assert(error != null);

  @override
  List<Object> get props => [error];
}

/// Product (List)
class ProductListInitial extends ProductState {}

class ProductListLoadInProgress extends ProductState {}

class ProductListLoadSuccess extends ProductState {
  final ProductList productList;
  final Category category;

  const ProductListLoadSuccess({@required this.productList, this.category})
      : assert(productList != null);

  @override
  List<Object> get props => [productList, category];
}

class ProductListLoadFailure extends ProductState {
  final dynamic error;
  ProductListLoadFailure({this.error});

  @override
  List<Object> get props => [error];
}

/// Product (Edit/Create)
class ProductEditInitial extends ProductState {
  final String tag;
  final ProductDetail product;
  final ModifyStep modifyStep;
  const ProductEditInitial({this.tag, this.product, this.modifyStep});

  @override
  List<Object> get props => [tag, product];
}

class ProductEditSuccess extends ProductState {
  final String tag;
  final ModifyStep step;
  const ProductEditSuccess({@required this.tag, @required this.step})
      : assert(tag != null && step != null);

  @override
  List<Object> get props => [tag];
}

class ProductEditFailure extends ProductState {
  final String error;
  const ProductEditFailure({@required this.error}) : assert(error != null);
}

class ProductEditLoading extends ProductState {}
