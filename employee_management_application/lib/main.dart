import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'features/employee/presentation/pages/dashboard_page.dart';
import 'features/employee/data/datasources/employee_remote_data_source.dart';
import 'features/employee/data/repositories/employee_repository_impl.dart';
import 'features/employee/presentation/providers/employee_providers.dart';

void main() {
  final dio = Dio();
  final remoteDataSource = EmployeeRemoteDataSourceImpl(dio: dio);
  final employeeRepository = EmployeeRepositoryImpl(remoteDataSource: remoteDataSource);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EmployeeProvider(employeeRepository)),
        Provider<EmployeeRepositoryImpl>.value(value: employeeRepository),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: const DashboardPage(),
    );
  }
}
