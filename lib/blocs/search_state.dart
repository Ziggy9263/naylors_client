import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:naylors_client/models/models.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

/// Search (Singular)
class SearchInitial extends SearchState {}

class SearchLoadInProgress extends SearchState {}

class SearchLoadSuccess extends SearchState {
  final ProductList productList;

  const SearchLoadSuccess({@required this.productList})
      : assert(productList != null);

  @override
  List<Object> get props => [productList];
}

class SearchLoadFailure extends SearchState {
  final String request;
  final dynamic error;

  const SearchLoadFailure({@required this.request, @required this.error}) : assert(request != null && error != null);

  @override
  List<Object> get props => [request, error];
}
