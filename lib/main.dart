import 'package:employee_app/employee_bloc_components/employee_bloc.dart';
import 'package:employee_app/employee_bloc_components/employee_events.dart';
import 'package:employee_app/screens/homepage.dart';
import 'package:employee_app/services/db_service.dart';
import 'package:employee_app/ui_helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ObjectBox.create();

  runApp(BlocProvider(
      create: (context) => EmployeeBloc()..add(LoadEmployees()),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employees App',
      theme: ThemeData(
          floatingActionButtonTheme:
              const FloatingActionButtonThemeData(backgroundColor: APP_BLUE),
          appBarTheme: const AppBarTheme(
              color: APP_BLUE,
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 21))),
      home: const MyHomePage(title: 'Employee List'),
    );
  }
}
