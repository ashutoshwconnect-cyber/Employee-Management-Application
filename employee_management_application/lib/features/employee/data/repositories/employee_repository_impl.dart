import 'package:dartz/dartz.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/employee_remote_data_source.dart';
import '../models/employee_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource remoteDataSource;

  EmployeeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Employee>>> getEmployees() async {
    try {
      final remoteEmployees = await remoteDataSource.getEmployees();
      return Right(remoteEmployees);
    } on ServerException {
      return const Left(ServerFailure('Server Error'));
    }
  }

  @override
  Future<Either<Failure, Employee>> getEmployee(String id) async {
    try {
      final employee = await remoteDataSource.getEmployee(id);
      return Right(employee);
    } on ServerException {
      return const Left(ServerFailure('Server Error'));
    }
  }

  @override
  Future<Either<Failure, Employee>> createEmployee(Employee employee) async {
    try {
      final employeeModel = EmployeeModel.fromEntity(employee);
      final created = await remoteDataSource.createEmployee(employeeModel);
      return Right(created);
    } on ServerException {
      return const Left(ServerFailure('Server Error'));
    }
  }

  @override
  Future<Either<Failure, Employee>> updateEmployee(Employee employee) async {
    try {
      final employeeModel = EmployeeModel.fromEntity(employee);
      final updated = await remoteDataSource.updateEmployee(employeeModel);
      return Right(updated);
    } on ServerException {
      return const Left(ServerFailure('Server Error'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEmployee(String id) async {
    try {
      await remoteDataSource.deleteEmployee(id);
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure('Server Error'));
    }
  }
}
