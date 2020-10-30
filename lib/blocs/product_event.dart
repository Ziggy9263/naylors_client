import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
}

class ProductRequested extends ProductEvent {
  final String tag;

  const ProductRequested({@required this.tag}) : assert(tag != null);

  @override
  List<Object> get props => [tag];
}

class ProductListRequested extends ProductEvent {
  const ProductListRequested();

  @override
  List<Object> get props => [];
}
