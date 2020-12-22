import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:naylors_client/models/models.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class CategoryRequested extends CategoryEvent {
  final String id;

  const CategoryRequested({@required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];
}

class CategoryReset extends CategoryEvent {
  @override
  List<Object> get props => [];
}

class CategoryEditEvent extends CategoryEvent {
  final ModifyStep step;
  final String id;
  final Category category;

  const CategoryEditEvent({this.id, @required this.step, this.category})
      : assert(step != null);

  @override
  List<Object> get props => [id, step, category];
}

class CategoryListRequested extends CategoryEvent {
  const CategoryListRequested();

  @override
  List<Object> get props => [];
}
