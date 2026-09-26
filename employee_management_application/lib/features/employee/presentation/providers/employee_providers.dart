import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/employee.dart';
import '../../data/datasources/employee_remote_data_source.dart';
import '../../data/repositories/employee_repository_impl.dart';

class EmployeeProvider extends ChangeNotifier {
  final EmployeeRepositoryImpl repository;

  List<Employee> _employees = [];
  List<Employee> get employees => _employees;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  EmployeeProvider(this.repository) {
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await repository.getEmployees();
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (data) {
        _employees = data;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> deleteEmployee(String id) async {
    final result = await repository.deleteEmployee(id);
    return result.fold(
      (failure) {
        _error = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        fetchEmployees();
        return true;
      },
    );
  }
}
