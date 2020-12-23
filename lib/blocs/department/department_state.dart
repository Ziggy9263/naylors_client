import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:naylors_client/models/models.dart';

abstract class DepartmentState extends Equatable {
  const DepartmentState();

  @override
  List<Object> get props => [];
}

/// Department (Singular)
class DepartmentInitial extends DepartmentState {}

class DepartmentLoadInProgress extends DepartmentState {}

class DepartmentLoadSuccess extends DepartmentState {
  final Department department;

  const DepartmentLoadSuccess({@required this.department}) : assert(department != null);

  @override
  List<Object> get props => [department];
}

class DepartmentLoadFailure extends DepartmentState {}

/// Department (List)
class DepartmentListInitial extends DepartmentState {}

class DepartmentListLoadInProgress extends DepartmentState {}

class DepartmentListLoadSuccess extends DepartmentState {
  final DepartmentList departmentList;

  const DepartmentListLoadSuccess({@required this.departmentList})
      : assert(departmentList != null);

  @override
  List<Object> get props => [departmentList];
}

class DepartmentListLoadFailure extends DepartmentState {
  final dynamic error;
  DepartmentListLoadFailure({this.error});

  @override
  List<Object> get props => [error];
}

/// Department (Edit/Create)
class DepartmentEditInitial extends DepartmentState {
  final String id;
  final Department department;
  const DepartmentEditInitial({this.id, this.department});

  @override
  List<Object> get props => [id, department];
}

class DepartmentEditSuccess extends DepartmentState {
  final String id;
  const DepartmentEditSuccess({@required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];
}

class DepartmentEditFailure extends DepartmentState {
  final String error;
  const DepartmentEditFailure({@required this.error}) : assert(error != null);
}

class DepartmentEditLoading extends DepartmentState {}
