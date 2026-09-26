import 'package:employee_management_application/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

import 'features/employee/presentation/pages/dashboard_page.dart';
import 'features/employee/data/datasources/employee_remote_data_source.dart';
import 'features/employee/data/repositories/employee_repository_impl.dart';
import 'features/employee/presentation/providers/employee_providers.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  // Note: Please configure your Firebase project using `flutterfire configure` 
  // to generate firebase_options.dart, or provide the keys explicitly here.
  try {
    await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform, // Uncomment when flutterfire configured
    );
  } catch (e) {
    debugPrint("Firebase initialization failed (might be already initialized): $e");
  }

  final dio = Dio();
  final remoteDataSource = EmployeeRemoteDataSourceImpl(dio: dio);
  final employeeRepository = EmployeeRepositoryImpl(
    remoteDataSource: remoteDataSource,
  );
  
  final authRemoteDataSource = AuthRemoteDataSourceImpl(firebaseAuth: FirebaseAuth.instance);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRemoteDataSource: authRemoteDataSource),
        ),
        ChangeNotifierProvider(
          create: (_) => EmployeeProvider(employeeRepository),
        ),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: themeProvider.themeMode,
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.user != null) {
            return const DashboardPage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
