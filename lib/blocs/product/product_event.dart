import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:naylors_client/models/models.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
}

class ProductRequested extends ProductEvent {
  final String tag;

  const ProductRequested({@required this.tag}) : assert(tag != null);

  @override
  List<Object> get props => [tag];
}

class ProductReset extends ProductEvent {
  @override
  List<Object> get props => [];
}

class ProductEditEvent extends ProductEvent {
  final ModifyStep step;
  final String tag;
  final ProductDetail product;

  const ProductEditEvent({this.tag, @required this.step, this.product})
      : assert(step != null);

  @override
  List<Object> get props => [tag, step, product];
}

class ProductListRequested extends ProductEvent {
  const ProductListRequested();

  @override
  List<Object> get props => [];
}
