import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchRequested extends SearchEvent {
  final String data;

  const SearchRequested({@required this.data}) : assert(data != null);

  @override
  List<Object> get props => [data];
}

class SearchInit extends SearchEvent {
  const SearchInit();

  @override
  List<Object> get props => [];
}
