import 'package:dio/dio.dart';
import '../models/employee_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class EmployeeRemoteDataSource {
  Future<List<EmployeeModel>> getEmployees();
  Future<EmployeeModel> getEmployee(String id);
  Future<EmployeeModel> createEmployee(EmployeeModel employee);
  Future<EmployeeModel> updateEmployee(EmployeeModel employee);
  Future<void> deleteEmployee(String id);
}

class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final Dio dio;
  final String baseUrl = 'https://669b3f09276e45187d34eb4e.mockapi.io/api/v1';

  EmployeeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<EmployeeModel>> getEmployees() async {
    try {
      final response = await dio.get('$baseUrl/employee');
      return (response.data as List)
          .map((json) => EmployeeModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching employees: $e');
      throw ServerException();
    }
  }

  @override
  Future<EmployeeModel> getEmployee(String id) async {
    try {
      final response = await dio.get('$baseUrl/employee/$id');
      return EmployeeModel.fromJson(response.data);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<EmployeeModel> createEmployee(EmployeeModel employee) async {
    try {
      final response = await dio.post('$baseUrl/employee', data: employee.toJson());
      return EmployeeModel.fromJson(response.data);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<EmployeeModel> updateEmployee(EmployeeModel employee) async {
    try {
      final response = await dio.put('$baseUrl/employee/${employee.id}', data: employee.toJson());
      return EmployeeModel.fromJson(response.data);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteEmployee(String id) async {
    try {
      await dio.delete('$baseUrl/employee/$id');
    } catch (e) {
      throw ServerException();
    }
  }
}
