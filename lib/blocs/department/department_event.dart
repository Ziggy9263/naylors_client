import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:naylors_client/models/models.dart';

abstract class DepartmentEvent extends Equatable {
  const DepartmentEvent();
}

class DepartmentRequested extends DepartmentEvent {
  final String id;

  const DepartmentRequested({@required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];
}

class DepartmentReset extends DepartmentEvent {
  @override
  List<Object> get props => [];
}

class DepartmentEditEvent extends DepartmentEvent {
  final ModifyStep step;
  final String id;
  final Department department;

  const DepartmentEditEvent({this.id, @required this.step, this.department})
      : assert(step != null);

  @override
  List<Object> get props => [id, step, department];
}

class DepartmentListRequested extends DepartmentEvent {
  const DepartmentListRequested();

  @override
  List<Object> get props => [];
}
