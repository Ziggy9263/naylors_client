import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:naylors_client/repositories/repositories.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/blocs/blocs.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  final DepartmentRepository departmentRepository;

  DepartmentBloc({@required this.departmentRepository})
      : assert(departmentRepository != null),
        super(DepartmentInitial());

  @override
  Stream<DepartmentState> mapEventToState(DepartmentEvent event) async* {
    if (event is DepartmentReset) {
      yield DepartmentInitial();
    }
    if (event is DepartmentEditEvent) {
      yield DepartmentEditLoading();
      switch (event.step) {
        case ModifyStep.Initialize:
          try {
            final Department department =
                await departmentRepository.getDepartment(event.id);
            yield DepartmentEditInitial(id: event.id, department: department);
          } catch (_) {
            yield DepartmentEditInitial(id: event.id);
          }
          break;
        case ModifyStep.Create:
          yield DepartmentEditLoading();
          try {
            final Department department =
                await departmentRepository.createDepartment(event.department);
            yield DepartmentEditSuccess(id: department.id);
          } catch (_) {
            yield DepartmentEditFailure(error: _);
          }
          break;
        case ModifyStep.Update:
          yield DepartmentEditLoading();
          try {
            final Department department =
                await departmentRepository.updateDepartment(event.department);
            yield DepartmentEditSuccess(id: department.id);
          } catch (_) {
            yield DepartmentEditFailure(error: _);
          }
          break;
        case ModifyStep.Delete:
          yield DepartmentEditLoading();
          try {
            final Department department =
                await departmentRepository.deleteDepartment(event.department);
            yield DepartmentEditSuccess(id: department.id);
          } catch (_) {
            yield DepartmentEditFailure(error: _);
          }
          break;
        default:
          yield DepartmentEditFailure(error: "Foreign ModifyStep Given");
          break;
      }
    }
    if (event is DepartmentRequested) {
      yield DepartmentLoadInProgress();
      try {
        final Department department =
            await departmentRepository.getDepartment(event.id);
        yield DepartmentLoadSuccess(department: department);
      } catch (_) {
        yield DepartmentLoadFailure();
      }
    }
  }
}

class DepartmentListBloc extends Bloc<DepartmentEvent, DepartmentState> {
  final DepartmentRepository departmentRepository;

  DepartmentListBloc({@required this.departmentRepository})
      : assert(departmentRepository != null),
        super(DepartmentListInitial());

  @override
  Stream<DepartmentState> mapEventToState(DepartmentEvent event) async* {
    if (event is DepartmentListRequested) {
      yield DepartmentListLoadInProgress();
      try {
        final DepartmentList departmentList = await departmentRepository.getDepartments();
        yield DepartmentListLoadSuccess(departmentList: departmentList);
      } catch (_) {
        yield DepartmentListLoadFailure(error: _);
      }
    }
  }
}
