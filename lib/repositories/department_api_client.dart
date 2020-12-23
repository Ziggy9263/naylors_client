import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:naylors_client/models/models.dart';

class DepartmentApiClient {
  static const baseUrl = 'https://order.naylorsfeed.com';
  final http.Client httpClient;

  DepartmentApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<DepartmentList> fetchDepartments() async {
    final departmentsUrl = "$baseUrl/api/departments";
    final response = await this.httpClient.get(departmentsUrl);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = DepartmentList.fromJSON(response.body);
      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to Get Departments');
    }
  }

  Future<Department> getDepartment(String id) async {
    final departmentUrl = "$baseUrl/api/departments/$id";
    final response = await this.httpClient.get(departmentUrl);

    if (response.statusCode == 200) {
      var data = Department.fromJSON(jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Failed to Get Department $id');
    }
  }

  Future<DepartmentList> searchDepartments(String query) async {
    final departmentUrl = "$baseUrl/api/departments/?q=$query";
    final response = await this.httpClient.get(departmentUrl);

    if (response.statusCode == 200) {
      var data = DepartmentList.fromJSON(response.body);
      return data;
    } else {
      throw Exception('Search for $query failed!');
    }
  }
}
