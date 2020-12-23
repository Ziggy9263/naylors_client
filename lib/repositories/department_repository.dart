import 'package:meta/meta.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/repositories/repositories.dart';

class DepartmentRepository {
  final DepartmentApiClient departmentApiClient;

  DepartmentRepository({@required this.departmentApiClient})
      : assert(departmentApiClient != null);

  Future<DepartmentList> getDepartments() async {
    return departmentApiClient.fetchDepartments();
  }

  Future<DepartmentList> searchDepartments(String query) async {
    return departmentApiClient.searchDepartments(query);
  }

  Future<Department> getDepartment(String id) async {
    return departmentApiClient.getDepartment(id);
  }

  Future<Department> createDepartment(Department department) async {
    return (department);
  }

  Future<Department> updateDepartment(Department department) async {
    return (department);
  }

  Future<Department> deleteDepartment(Department department) async {
    return (department);
  }
}
